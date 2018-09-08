def add_template_repository_to_source_path
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

def ask_with_default(question, color, default)
  return default unless $stdin.tty?
  question = (question.split("?") << " [#{default}]?").join
  answer = ask(question, color)
  answer.to_s.strip.empty? ? default : answer
end

# Gems to use
def add_gems
  # Easy json generation
  gem 'acts_as_api'
  # Makes it possible to paginate results
  gem 'will_paginate'
  # Testing
  gem 'rspec'
  # API documentation and testing
  gem 'rswag'
  # Easy user authentication
  gem 'acts_as_hoc_user'
  # Easy push notifications through firebase
  gem 'acts_as_hoc_pushable'
  # Makes models notifiable, receivable and sendable
  gem 'hoc_notifications'
  # Service objects for rails
  gem 'simple_command'
  gem_group :development, :test do
    # Testing
    gem "rspec-rails"
  end
end

def set_application_name
  # Add Application Name to Config
  environment "config.application_name = Rails.application.class.parent_name"
  # Announce the user where he can change the application name in the future.
  puts "You can change application name inside: ./config/application.rb"
end

def api_accessible(name = "basic", field_names)
  api_accessible = "\n\tapi_accessible :#{name} do |t|\n"
  #api_accessible << "\t\t:id\n"
  #api_accessible << "\t\t:email\n"
  field_names.each do |field|
    api_accessible << "\t\tt.add #{field}\n"
  end
  api_accessible << "\tend\n"

  api_accessible
end


def install_user?
  if @install_user.nil?
    puts "\n\n"
    puts "------------------------------------------------------------------------------------------------------------------------"
    puts "A profile model will contain fields for credentials; password_digest and email. Extra fields can be added.\n"
    puts "------------------------------------------------------------------------------------------------------------------------"
    @install_user = ask_with_default("Install profile model? (y/n)", :green, "y") =~ /^y(es)?/i
  end
  @install_user
end

def install_notifications?
  if @install_notifications.nil?
    puts "------------------------------------------------------------------------------------------------------------------------"
    puts "Notification makes it easy to notify users.\n"
    puts "------------------------------------------------------------------------------------------------------------------------"
    @install_notifications = ask_with_default("Install hoc_notifications? (y/n)", :green, "y") =~ /^y(es)?/i
  end
  @install_notifications
end

def profile_extras
  if @profile_extras.nil?
    puts "------------------------------------------------------------------------------------------------------------------------"
    puts "Extra fields for profile.\n"
    puts "------------------------------------------------------------------------------------------------------------------------"
    @profile_extras = ask_with_default("Enter the extra fields for the profile model.\nEg. name:string address:string age:integer:\n", :green, "name:string")
  end
  @profile_extras
end

def add_users
  # Ask if we should add an user model
  if install_user?
    directory "templates/users/app", "app", force: true
    directory "templates/users/config", "config", force: true
    generate "acts_as_hoc_user:hoc_user user #{profile_extras}"
    generate 'acts_as_hoc_pushable:install'

    # Should we install hoc notifications

    splitted_fields = profile_extras.split(" ").map { |field|
      { name: "#{field.split(":")[0]}", type: "#{field.split(":")[1]}", all: field, index: "#{field.split(":")[2] ||= nil}"}
    }

    field_names = splitted_fields.map { |field| ":#{field[:name]}" }

    # Generates api_accessable for user
    api_accessible = api_accessible("basic", [":id", ":email"] + field_names)

      # Insert extra stuff into user
    insert_into_file(
      'app/models/user.rb',
      "\n\tacts_as_hoc_pushable\n#{"\tacts_as_hoc_notifications_receiver\n\tacts_as_hoc_notifications_sender\n" if install_notifications?}\tacts_as_api\n#{api_accessible}\n",
      after: 'acts_as_hoc_user'
    )

    # Permit user fields in controller
    gsub_file "app/controllers/api/v1/profiles_controller.rb",
      "params.require(:profile).permit!",
      "params.require(:profile).permit(:email, :password, :password_confirmation, #{field_names.join(",")})"


    add_notifications if install_notifications?

    insert_user_definitions(splitted_fields)
    insert_session_definitions

  end
end

def add_notifications
  # Install hoc_notifications
  generate 'hoc_notifications:install'
  # Add templates
  directory "templates/hoc_notifications/config", "config", force: true
  directory "templates/hoc_notifications/app", "app", force: true
  directory "templates/hoc_notifications/spec", "spec", force: true
  # Add resources to route
  insert_into_file(
    'config/routes.rb',
    "\n\t\t\tresources :notifications, only: [:index, :show] do\n\t\t\t\tput :mark_as_seen, on: :collection\n\t\t\t\tput :mark_as_seen, on: :member\n\t\t\tend\n\n",
    after: '# add your routes here.'
  )
  insert_notifications_definitions

end

def stop_spring
  run 'spring stop'
end

def insert_notifications_definitions
  note_defs = %q(
    notification: {
      description: 'This model contains information about a notification',
      type: 'object',
      properties: {
        id: { type: 'integer' },
        title: { type: 'string' },
        message: { type: 'string' },
        action: { type: 'string' },
        sender_id: { type: 'integer' },
        sender_type: { type: 'string' },
        notifiable_id: { type: 'integer' },
        notifiable_type: { type: 'string' },
        data: { type: 'string', description: 'json with extra data' },
      },
    },
    notifications: {
      description: 'An array of notifications',

        type: 'array',
        items: { "$ref": "#/definitions/notification" },

    },
  )
  insert_into_file(
    'spec/swagger_helper.rb',
    "#{note_defs}\n",
    after: '# add your definitions here.'
  )
end

def insert_session_definitions

  session_defs = %q(
        session_input: {
          description: 'This model contains information for logging in an user',
          type: 'object',
          properties: {
            password: { type: 'string', format: 'password' },
            email: { type: 'string', format: 'email' },
          },
          required: ['password', 'email']
        },
        session: {
          description: 'This model contains information for logging in an user',
          type: 'object',
          properties: {
            authentication_token: { type: 'string' },
            profile: { "$ref": "#/definitions/profile" },
          },
        },
  )
  insert_into_file(
    'spec/swagger_helper.rb',
    "#{session_defs}\n",
    after: '# add your definitions here.'
  )
end


def insert_user_definitions(fields)
  directory "templates/users/spec", "spec", force: true
  user_defs = %q(
        profile_input: {
          description: 'This model contains information for creating an user',
          type: 'object',
          properties: {
            email: { type: 'string', format: 'email' },
            password: { type: 'string', format: 'password' },
            password_confirmation: { type: 'string', format: 'password' },
  )

  fields.each do |field|
    user_defs = user_defs + "\t\t\t\t#{field[:name]}: { type: '#{field[:type]}' },"
  end
  user_defs = user_defs + %q(
          },
          required: ['email']
        },
        profile: {
          description: 'This model contains information about an user',
          type: 'object',
          properties: {
            id: { type: 'integer' },
            email: { type: 'string', format: 'email' },
  )
  fields.each do |field|
    user_defs = user_defs + "\t\t\t\t#{field[:name]}: { type: '#{field[:type]}' },"
  end
  user_defs = user_defs + %q(
          }
        },
        device: {
          description: 'This model contains information for adding a device to a profile',
          type: 'object',
          properties: {
            token: { type: 'string' },
            platform: { type: 'string', description: 'ios or android' },
            platform_version: { type: 'string', description: 'eg. 9.3' },
            push_environment: { type: 'string', description: 'production or debug' },
          },
          required: ['token', 'platform', 'platform_version', 'push_environment']
        },
  )
  insert_into_file(
    'spec/swagger_helper.rb',
    "#{user_defs}\n",
    after: '# add your definitions here.'
  )
end

if install_user?
  profile_extras
  install_notifications?
end


add_template_repository_to_source_path

add_gems
after_bundle do
  set_application_name
  stop_spring

  # Add swagger and specs for user
  generate 'rspec:install'
  generate 'rswag:install'
  directory "templates/spec", "spec", force: true

  # add user
  add_users

  comment_lines 'config/initializers/new_framework_defaults.rb', /Rails.application.config.action_controller.raise_on_unfiltered_parameters/


  # Migrate
  rails_command "db:drop"
  rails_command "db:create"
  rails_command "db:migrate"
  generate 'rswag:specs:swaggerize'
  # Initialize git and make a initial commit
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
