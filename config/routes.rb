  # other routes...
  namespace :api do
    resources :users, only: %i[index create show update] do
      member do
        put 'restrict'
      end
    end
    # other resources...
    resources :notifications, only: [:show] do
      collection do
        get ':user_id', to: 'notifications#get_notifications'
      end
    end
  end
  # other routes...
end
