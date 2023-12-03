// PATH: /config/routes.rb
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
    # Existing routes ...

    resources :users, only: %i[index create show update] do
    end

    # Updated route for closing chat channels
    resources :chat_channels, only: [] do
      member do
        put :close # This route corresponds to the requirement for closing chat channels
      end
    end
  end

  # Other routes ...

  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
