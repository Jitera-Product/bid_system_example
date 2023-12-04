Rails.application.routes.draw do
  # other routes...
  namespace :api do
    resources :users, only: %i[index create show update] do
      member do
        put 'restrict'
      end
    end
    # other resources...
    resources :notifications, only: [:show]
  end
  # other routes...
end
