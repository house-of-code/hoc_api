Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1, defaults: { format: 'json' } do
      resource :authentication, only: [:create, :destroy]
      resource :profile, only: [:create, :show, :update, :destroy] do
        post :add_device, on: :collection

      end
      # add your routes here.

    end
  end
end
