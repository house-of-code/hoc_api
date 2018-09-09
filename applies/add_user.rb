return unless install_user?

info "Installing user model"
generate "acts_as_hoc_user:hoc_user user #{profile_extras}"

info "installing acts_as_hoc_pushable"
generate 'acts_as_hoc_pushable:install'

info "installing controllers"
directory "templates/users/app", "app", force: true
directory "templates/users/config", "config", force: true

info "update user model"
# Generates api_accessable for user
api_accessible = api_accessible("basic", [":id", ":email"] + user_field_names)
# Insert extra stuff into user
insert_into_file 'app/models/user.rb', after: 'acts_as_hoc_user' do
  <<-ACTS
    acts_as_hoc_pushable
    #{"acts_as_hoc_notifications_receiver" if install_notifications?}
    #{"acts_as_hoc_notifications_sender" if install_notifications?}
    acts_as_api
    #{api_accessible}
  ACTS
end

# Add authentication methods for api_controller.rb and inject fields to profile controller permitted params
apply("applies/users/api_controller.rb")

info "Generate API documentation for authentication and profile"
# Create api documentation
directory "templates/users/spec", "spec", force: true
apply "applies/api_definitions/profiles.rb"
apply "applies/api_definitions/sessions.rb"

apply("applies/add_notifications.rb") if install_notifications?
