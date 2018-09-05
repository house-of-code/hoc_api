Rails.application.routes.draw do
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
