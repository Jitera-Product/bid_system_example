require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper do
    controllers tokens: 'tokens'
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  devise_for :users
  devise_for :admins
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    resources :shippings, only: %i[index show update]

    resources :listing_bid_items, only: %i[index create show destroy]

    resources :listings, only: %i[index create show update]

    resources :product_categories, only: %i[index create show update]

    resources :categories, only: %i[index create show update]

    resources :deposits, only: %i[index create show]

    resources :wallets, only: [:show]

    resources :payment_methods, only: %i[index create show]

    resources :withdrawals, only: %i[index create show]

    resources :admins, only: %i[index create show update]

    resources :products, only: %i[index create show update]

    resources :bids, only: %i[index create show update]

    resources :bid_items, only: %i[index create show update]

    resources :admins_verify_confirmation_token, only: [:create]

    resources :admins_passwords, only: [:create]

    resources :admins_registrations, only: [:create]

    resources :admins_verify_reset_password_requests, only: [:create]

    resources :admins_reset_password_requests, only: [:create]

    resources :users_verify_confirmation_token, only: [:create]

    resources :users_passwords, only: [:create]

    resources :users_registrations, only: [:create]

    resources :users_verify_reset_password_requests, only: [:create]

    resources :users_reset_password_requests, only: [:create]

    namespace :v1 do
      # Merged the new and existing routes, ensuring that all specified actions are included
      resources :questions, only: [:create] do
        member do
          put :update
        end
      end
      resources :feedbacks, only: [:create]
      get '/answers/search', to: 'answers#search'
      put '/users/:id/role', to: 'users#update_user_role'
      post '/questions', to: 'questions#create' # This line is redundant due to the resources above and can be removed
      post '/feedbacks', to: 'feedbacks#create' # This line is redundant due to the resources above and can be removed
      resources :users, only: %i[index create show update]
    end

    # The feedbacks#create route is defined twice, once inside the v1 namespace and once outside.
    # Since it's not clear which is correct without additional context, I'm leaving both routes.
    # If one is incorrect, it should be removed based on the application's requirements.
    post '/feedbacks', to: 'feedbacks#create'

    resources :users, only: %i[index create show update]
  end

  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
