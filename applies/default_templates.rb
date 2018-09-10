info "Adding templates."
directory "templates/default/app", "app", force: true
directory "templates/default/public", "public", force: true
directory "templates/default/lib", "lib", force: true
directory "templates/default/config", "config", force: true
template 'templates/default/README.md.erb', "README.md", force: true
# Uncomment Rails.application.config.action_controller.raise_on_unfiltered_parameters
#comment_lines 'config/initializers/new_framework_defaults.rb', /Rails.application.config.action_controller.raise_on_unfiltered_parameters/
