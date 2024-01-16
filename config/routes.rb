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
    resources :shippings, only: %i[index show update] do
    end

    resources :listing_bid_items, only: %i[index create show destroy] do
    end

    resources :listings, only: %i[index create show update] do
    end

    resources :product_categories, only: %i[index create show update] do
    end

    resources :categories, only: %i[index create show update] do
    end

    resources :deposits, only: %i[index create show] do
    end

    resources :wallets, only: [:show] do
    end

    resources :payment_methods, only: %i[index create show] do
    end

    resources :withdrawals, only: %i[index create show] do
    end

    resources :admins, only: %i[index create show update] do
    end

    resources :products, only: %i[index create show update] do
    end

    resources :bids, only: %i[index create show update] do
    end

    resources :bid_items, only: %i[index create show update] do
    end

    resources :admins_verify_confirmation_token, only: [:create] do
    end

    resources :admins_passwords, only: [:create] do
    end

    resources :admins_registrations, only: [:create] do
    end

    resources :admins_verify_reset_password_requests, only: [:create] do
    end

    resources :admins_reset_password_requests, only: [:create] do
    end

    resources :users_verify_confirmation_token, only: [:create] do
    end

    resources :users_passwords, only: [:create] do
    end

    resources :users_registrations, only: [:create] do
    end

    resources :users_verify_reset_password_requests, only: [:create] do
    end

    resources :users_reset_password_requests, only: [:create] do
    end

    post 'admins/moderate_content', to: 'admins#moderate_content'
    post 'feedback', to: 'feedback#create' # Added route for feedback creation

    # Resolving conflict for user role update route
    # We keep both the put and patch routes for backward compatibility
    put 'users/:id/role', to: 'users#update_role', as: 'update_user_role'
    patch 'users/:id/update_role', to: 'users#update_role'

    post '/api/questions', to: 'api/questions#create'
    # Updated to meet the requirement
    put '/questions/:id', to: 'questions#update'

    namespace :v1 do
      resources :answers, only: [:create]
      put 'answers/:id', to: 'answers#update' # Updated to meet the requirement
      get 'answers/search', to: 'answers#search' # Added to meet the requirement from existing code
    end

    resources :users, only: %i[index create show update] do
    end
  end

  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
