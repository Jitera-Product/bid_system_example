Rails.application.routes.draw do
  namespace :api do
    resources :users_registrations, only: [:create]
  end
  resources :feedbacks, only: [:create]
end
