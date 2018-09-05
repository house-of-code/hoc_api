
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
  #   source_paths.unshift(File.dirname(__FILE__))
  # end
end


# Gems to use
def add_gems
  gem 'acts_as_api'
  gem 'will_paginate'
  gem 'rspec-rails', '~> 3.5'
  gem 'rswag'
  gem 'acts_as_hoc_user'
  gem 'acts_as_hoc_pushable'
  gem 'hoc_notifications'
  gem 'simple_command'
end

def set_application_name
  # Add Application Name to Config
  environment "config.application_name = Rails.application.class.parent_name"

  # Announce the user where he can change the application name in the future.
  puts "You can change application name inside: ./config/application.rb"
end

def add_users
  if yes?("Install user? (y/n)\n")

    user_fields = ask("\nEnter the extra fields for the user model.\nEg. name:string address:string age:integer:\n")
    use_notifications = yes?("\nInstall hoc_notifications? (y/n)\n")
    directory "templates/users/app", "app", force: true
    directory "templates/users/config", "config", force: true
    generate "acts_as_hoc_user:hoc_user user #{user_fields}"
    generate 'acts_as_hoc_pushable:install'
    field_names = user_fields.split(" ").map { |field| ":#{field.split(":").first}" }
    api_accessible = "\n\tapi_accessible :basic do |t|\n"
    api_accessible << "\t\t:id\n"
    api_accessible << "\t\t:email\n"
    field_names.each do |field|
      api_accessible << "\t\t#{field}\n"
    end
    api_accessible << "\tend\n"

    # Make user ready to be notication_receiver and pushable
    insert_into_file(
      'app/models/user.rb',
      "\n\tacts_as_hoc_pushable\n#{"\tacts_as_hoc_notification_receiver\n\tacts_as_hoc_notification_sender\n" if use_notifications}\tacts_as_api\n#{api_accessible}\n",
      after: 'acts_as_hoc_user'
    )

    # Permit fields in controller
    gsub_file "app/controllers/api/v1/profiles_controller.rb",
      "params.require(:user).permit!",
      "params.require(:user).permit(:email, :password, :password_confirmation, #{field_names.join(",")})"

    add_notifications if use_notifications

    # TODO setup api documentation

  end
end

def add_notifications
  generate 'hoc_notifications:install'
  uncomment_lines 'app/models/user.rb', /#acts_as_hoc_notification/
  directory "templates/hoc_notifications/config", "config", force: true
  directory "templates/hoc_notifications/app", "app", force: true
  insert_into_file(
    'config/routes.rb',
    "\n\t\t\tresources :notifications, only: [:index, :show] do\n\t\t\t\tpost :mark_as_seen, on: :collection\n\t\t\tend\n\n",
    after: '# add your routes here.'
  )
  # TODO setup api documentation

end

def stop_spring
  run 'spring stop'
end

add_template_repository_to_source_path

add_gems
after_bundle do
  set_application_name
  stop_spring
  add_users
  # Migrate
  rails_command "db:create"
  rails_command "db:migrate"
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
