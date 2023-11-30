Rails.application.routes.draw do
  namespace :api do
    resources :users_registrations, only: [:create]
    post '/users/register', to: 'users_registrations#register'
    resources :users do
      member do
        get :matches
        put :update
      end
      resources :matches do
        post 'swipe', to: 'users#swipe'
        resources :messages, only: [:create]
      end
    end
  end
  resources :feedbacks, only: [:create]
end
