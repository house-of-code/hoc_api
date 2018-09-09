info "running migration"
rails_command "db:drop"
rails_command "db:create"
rails_command "db:migrate"
