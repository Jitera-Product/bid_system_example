Rails.application.routes.draw do
  ...
  namespace :api do
    ...
    resources :users, only: %i[index create show update] do
      resources :kyc_documents, only: [:create]
      member do
        put 'manual_kyc_verification'
      end
    end
  end
  ...
end
