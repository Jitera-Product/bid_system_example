Rails.application.routes.draw do
  # existing routes...
  namespace :api do
    # existing routes...
    resources :users, only: %i[index create show update] do
      resources :kyc_documents, only: [:create]
      member do
        put 'manual_kyc_verification'
        put 'update_kyc_status'
      end
    end
  end
end
