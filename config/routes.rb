Rails.application.routes.draw do
  # other routes...
  namespace :api do
    # other routes...
    resources :users, only: %i[index create show update] do
    end
    put 'users/:id/restrict_features', to: 'users#restrict_features'
  end
  # other routes...
end
