Rails.application.routes.draw do
  resource :session, only: %i[ new create destroy ]
  resources :passwords, param: :token, only: %i[ edit update ]

  resources :names, only: %i[ index ] do
    post :vote, on: :member
  end
  resources :decided_names, only: %i[ index destroy ]

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "names#index"
end
