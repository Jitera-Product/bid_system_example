Rails.application.routes.draw do
  namespace :api do
    resources :users_registrations, only: [:create]
    resources :users do
      resources :matches do
        post 'swipe', to: 'users#swipe'
        resources :messages, only: [:create]
      end
    end
  end
  resources :feedbacks, only: [:create]
end
