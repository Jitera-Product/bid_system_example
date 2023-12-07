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

    resources :users, only: %i[index create show update]

    # Added route for chat_channels as per the guideline
    resources :chat_channels, only: [:create]

    # Added route for messages API endpoint
    resources :messages, only: [:show], param: :chat_channel_id
  end

  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
