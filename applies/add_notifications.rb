unless install_notifications?
  return
end
info "generates notifications model"
# Install hoc_notifications
generate 'hoc_notifications:install'

info "generates notifications controller "
# Add templates
directory "templates/hoc_notifications/config", "config", force: true
directory "templates/hoc_notifications/app", "app", force: true

info "adds routes for notifications"
# Add resources to route
apply "applies/routes/notifications_routes.rb"

info "generates api documentation for notifications"
# Create api documentation
directory "templates/hoc_notifications/spec", "spec", force: true
apply "applies/api_definitions/notifications.rb"
