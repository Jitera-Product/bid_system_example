Rails.application.routes.draw do
  namespace :api do
    resources :users, only: %i[index create show update] do
      post 'submit_kyc', on: :collection
    end
    resources :notifications, only: [:show]
    post '/kyc', to: 'kyc_documents#create'
  end
end
