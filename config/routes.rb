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
        get 'filter', to: 'notifications#filter'
      end
    end
    resources :bid_items, only: [:index]
    resources :listing_bid_items, only: [:show] # Add this line
    resources :users_reset_password_requests, only: [:create]
    # other resources...
    post 'users_registrations', to: 'users#create'
  end
  # other routes...
  get '/notifications/:id', to: 'notifications#show'
end
