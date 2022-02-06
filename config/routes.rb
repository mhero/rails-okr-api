require 'sidekiq/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :goals, only: [:index, :create] do
    post :batch, on: :collection
    resources :key_results, only: [:create]
  end

  mount Sidekiq::Web => '/sidekiq'

  post 'authenticate', to: 'authentication#authenticate'
end
