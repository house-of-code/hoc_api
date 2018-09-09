insert_into_file 'config/routes.rb', after: '# add your routes here.' do
  <<-ROUTES
  
        resources :notifications, only: [:index, :show] do
          put :mark_as_seen, on: :collection
          put :mark_as_seen, on: :member
        end
  ROUTES
end
