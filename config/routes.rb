Rails.application.routes.draw do
  
  resources :appliances
  resources :zones
  resources :hosts
  resources :accounts
  
  resources :storage_pools do
    member do
      get :volumes
      post :refresh
    end
  end

  resources :users
  resources :transactions
  resources :tariffs
  resources :addresses_networks
  resources :addresses
  resources :networks
  resources :servers_volumes

  resources :volumes do
    member do
      get :attachments
    end
  end

  resources :servers do
    member do
      get :storage, :network, :console, :debug
      post :start, :pause, :unpause, :suspend, :stop, :reset
    end
  end

  resources :bundles

  root "pages#index"
  get 'boom' => 'pages#boom'

  match 'errors/:status' => 'pages#error', via: :all

end
