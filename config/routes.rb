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

    resources :chat_channels, only: %i[create index show] do
      member do
        patch :disable
        get :messages, to: 'chat_channels#messages' # This line is from the existing code and should be kept
        put :disable # This line is from the new code and should be merged
      end
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

    resources :users, only: %i[index create show update] do
    end

    post '/messages', to: 'messages#create'
  end

  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
