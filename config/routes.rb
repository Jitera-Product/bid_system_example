Rails.application.routes.draw do
  # other routes...
  namespace :api do
    resources :users, only: %i[index create show update] do
      member do
        put 'restrict'
      end
    end
    resources :notifications, only: [:show] do
      collection do
        get ':user_id', to: 'notifications#get_notifications'
      end
    end
    # other resources...
  end
  # other routes...
end
