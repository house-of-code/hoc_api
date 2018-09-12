return unless install_user?

info "Installing user model."

generate "acts_as_hoc_user:hoc_user user #{profile_extras}"

info "installing acts_as_hoc_pushable."
generate 'acts_as_hoc_pushable:install'

info "installing controllers."
directory "templates/users/app", "app", force: true
directory "templates/users/config", "config", force: true

info "Generate API documentation for authentication and profile."
# Create api documentation
directory "templates/users/spec", "spec", force: true

apply("applies/add_notifications.rb") if install_notifications?

if enable_user_avatar?
  info "installing acts_as_hoc_avatarable."
  generate 'acts_as_hoc_avatarable:install'
  environment "config.active_storage.service = :local", env: :development
end
