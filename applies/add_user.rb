return unless install_user?

info "Installing user model."

generate "acts_as_hoc_user:hoc_user user #{profile_extras}"

info "installing acts_as_hoc_pushable."
generate 'acts_as_hoc_pushable:install'

# Generates api_accessable for user


info "installing controllers."
directory "templates/users/app", "app", force: true
directory "templates/users/config", "config", force: true

# # Insert extra stuff into user
# insert_into_file 'app/models/user.rb', after: 'acts_as_hoc_user' do
#   <<-ACTS
#     acts_as_hoc_pushable
#     #{"acts_as_hoc_notifications_receiver" if install_notifications?}
#     #{"acts_as_hoc_notifications_sender" if install_notifications?}
#     acts_as_api
#     #{api_accessible}
#   ACTS
# end

info "Generate API documentation for authentication and profile."
# Create api documentation
directory "templates/users/spec", "spec", force: true


apply("applies/add_notifications.rb") if install_notifications?

if enable_user_avatar?
  info "installing active storage."
  rails_command 'active_storage:install'

  environment "config.default_url_options = { host: 'localhost:3000' }", env: :development
  environment "config.active_storage.service = :local", env: :development
end
