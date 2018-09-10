def run_template
  unless (Rails::VERSION::MAJOR > 5) || (Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR >= 2)
    say_error "This template requires minimum Rails 5.2"
    die
  end

  add_template_repository_to_source_path
  hr_line
  info "Welcome to House of Code' Ruby on Rails template generator."
  hr_line(true)


  # Ask questions up front so we have the values for templates...
  if install_user?
    if advanced_user_setup?
      profile_extras
    else
      @profile_extras = "name:string:index"
    end
    if enable_user_avatar?
    end
    install_notifications?
  end
  enable_cors?
  enable_pundit?
  if enable_admin?
    admin_login
    admin_password
  end

  info "adding gems"
  apply("applies/gems.rb")

  hr_line
  say("running bundle to install gems. This can take some time - grab a cup of coffee :-)", :yellow, :bold)
  hr_line(true)

  after_bundle do
    # Set application name
    set_application_name

    # Stop spring
    apply("applies/stop_spring.rb")

    # default app templates
    apply("applies/default_templates.rb")

    directory "templates/cors/config", "config", force: true if enable_cors?

    # rswag setup
    apply("applies/rswag_setup.rb")

    # add user
    apply("applies/add_user.rb")

    # install pundit and include pundit in application controller
    apply("applies/pundit_setup.rb")

    # root route
    info "Adds route for default page."
    route "root to: 'home#index'"

    # Migrate
    apply("applies/migration.rb")

    # Generate api documentation for swagger
    rails_command 'rswag:specs:swaggerize'

    # binstub
    binstub_setup

    # Rakefile
    info "Adding to Rakefile."
    apply("applies/rakefile.rb")

    # Administrative
    apply("applies/admin.rb")

    # rubocup
    run_rubocop_autocorrections

    # Initialize git and make a initial commit
    apply("applies/git_setup.rb")

    info "Installation finished."
  end
end

def add_template_repository_to_source_path
  ## The following would work if it was a public git repo
  # if __FILE__ =~ %r{\Ahttps?://}
  #   require "tmpdir"
  #   source_paths.unshift(tempdir = Dir.mktmpdir("rails-template-"))
  #   at_exit { FileUtils.remove_entry(tempdir) }
  #   git clone: [
  #     "--quiet",
  #     "git://bitbucket.org/houseofcode/rails-template/raw/master/hoc_api_template.rb",
  #     tempdir
  #   ].map(&:shellescape).join(" ")
  #
  #   if (branch = __FILE__[%r{rails-template/raw/(.+)/hoc_api_template.rb}, 1])
  #     Dir.chdir(tempdir) { git checkout: branch }
  #   end
  # else
     source_paths.unshift(File.dirname(__FILE__))
  # end
end


def set_application_name
  # Add Application Name to Config
  environment "config.application_name = Rails.application.class.parent_name"
end

def api_accessible(name = "basic", field_names)
  api_accessible = "\n\tapi_accessible :#{name} do |t|\n"
  field_names.each do |field|
    api_accessible << "\t\tt.add #{field}\n"
  end
  api_accessible << "\tend\n"
  api_accessible
end

def splitted_user_fields
  return @splitted_fields if defined? @splitted_fields
  @splitted_fields = profile_extras.split(" ").map { |field|
    {
      name: "#{field.split(":")[0]}",
      type: "#{field.split(":")[1]}",
      index: "#{field.split(":")[2] ||= nil}",
      all: field
    }
  }
end

def user_field_names
  return @user_field_names if defined? @user_field_names
  @user_field_names = splitted_user_fields.map { |field|
    ":#{field[:name]}"
  }
end

def profile_definitions_spec

  return @profile_definitions_spec if defined? @profile_definitions_spec
  @profile_definitions_spec = ""
  splitted_user_fields.each do |field|
    @profile_definitions_spec << "#{field[:name]}: { type: '#{field[:type]}' },"
  end
  @profile_definitions_spec
end


def binstub_setup
  info "Runs bundle binstubs."
  binstubs = %w[
    annotate bundler rubocop brakeman
  ]
  run_with_clean_bundler_env "bundle binstubs #{binstubs.join(' ')} --force"
end

def run_rubocop_autocorrections
  info "Adding rubocop and running auto corrections."
  template "templates/rubocop/rubocop.yml", "rubocop.yml"
  run_with_clean_bundler_env "bin/rubocop -a --fail-level A > /dev/null || true"
  #run_with_clean_bundler_env "bin/rubocop -a --fail-level A  || true"
end

def run_with_clean_bundler_env(cmd)
  success = if defined?(Bundler)
              Bundler.with_clean_env { run(cmd) }
            else
              run(cmd)
            end
  unless success
    error "Command failed, exiting: #{cmd}", :red
    exit(1)
  end
end

###
### Questions
###

def install_user?
  return @install_user if defined? @install_user
  hr_line
  info "User model and user authentication and profile api controller."
  info "A user model will contain fields for credentials; password_digest and email. Extra fields can be added."
  hr_line(true)
  @install_user = ask_with_default("Install user model, authentication and profile controllers? (y/n)", :cyan, "y") =~ /^y(es)?/i
end

def install_notifications?
  return @install_notifications if defined? @install_notifications
  hr_line
  info "Notification makes it easy to notify users."
  hr_line(true)
  @install_notifications = ask_with_default("Install hoc_notifications model and controllers? (y/n)", :cyan, "y") =~ /^y(es)?/i

end

def advanced_user_setup?
  return @advanced_user_setup if defined? @advanced_user_setup
  hr_line
  info "You can customize the fields of the user model or leave them to the default:"
  warning "email, password_digest, name"
  hr_line(true)
  @advanced_user_setup = ask_with_default("Advanced user model setup? (y/n)", :cyan, "no") =~ /^y(es)?/i
end

def profile_extras
  return @profile_extras if defined? @profile_extras
  hr_line
  info "Extra fields for user model."
  info "The user model contains the following fields per default:"
  warning "email and password_digest"
  info "Example: "
  say("address:string age:integer phone:string:index", :bold)
  hr_line(true)
  @profile_extras = ask_with_default("Enter the extra fields for the user model?", :cyan)
end

def enable_user_avatar?
  return @enable_user_avatar if defined? @enable_user_avatar
  hr_line
  info "Add an avatar to the user model"
  hr_line(true)
  @enable_user_avatar = ask_with_default("Enable avatar for user model? (y/n)", :cyan, "y") =~ /^y(es)?/i
end

def enable_pundit?
  return @enable_pundit if defined? @enable_pundit
  hr_line
  info "Pundit for resource authentication"
  hr_line(true)
  @enable_pundit = ask_with_default("Enable pundit? (y/n)", :cyan, "y") =~ /^y(es)?/i
end

def enable_cors?
  return @enable_cors if defined? @enable_cors
  hr_line
  info "Accept Cross origin resource sharing (CORS)"
  hr_line(true)
  @enable_cors = ask_with_default("Enable CORS? (y/n)", :cyan, "no") =~ /^y(es)?/i
end

def enable_admin?
  return @enable_admin if defined? @enable_admin
  hr_line
  info "Administration module"
  hr_line(true)
  @enable_admin = ask_with_default("Enable admin? (y/n)", :cyan, "y") =~ /^y(es)?/i
end

def admin_login
  return @admin_login if defined? @admin_login
  hr_line
  info "Enter login name for admin interface"
  hr_line(true)
  @admin_login = ask_with_default("Login?", :cyan, "admin")
end

def admin_password
  return @admin_password if defined? @admin_password
  hr_line
  info "Enter login password for admin interface"
  hr_line(true)
  @admin_password = ask_with_default("Password?", :cyan, "")
end

###
### TEXT HELPERS
###

# Creates a question with default value
def ask_with_default(question, color, default = "")
  return default unless $stdin.tty?
  unless default.strip.empty?
    question = (question.split("?") << " [#{default}]?").join
  end
  answer = ask(question, color)
  answer.to_s.strip.empty? ? default : answer
end

def hr_line(extra_line = false)
  info "------------------------------------------------------------------------------------------------------------------------"
  puts "\n" if extra_line
end

def say_error(text)
  say(text, :red)
end

def info(text)
  say(text, :green)
end

def warning(text)
  say(text, :yellow)
end

run_template
