return unless install_notifications?

# Install hoc_notifications
info "generates notifications model."
generate 'hoc_notifications:install'

# Add templates
info "generates notifications controller."
directory "templates/hoc_notifications/config", "config", force: true
directory "templates/hoc_notifications/app", "app", force: true

# Create api documentation
info "generates api documentation for notifications."
directory "templates/hoc_notifications/spec", "spec", force: true
