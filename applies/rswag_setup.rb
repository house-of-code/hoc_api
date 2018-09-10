info "Adding rswag api documentation."
# Add swagger and spec skeleton
generate 'rspec:install'
generate 'rswag:install'
directory "templates/default/spec", "spec", force: true
