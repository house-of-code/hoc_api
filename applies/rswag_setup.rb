info "Adding rswag api documentation"
# Add swagger and spec skeleton
generate 'rspec:install'
generate 'rswag:install'
directory "templates/spec", "spec", force: true
