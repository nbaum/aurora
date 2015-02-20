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
  resources :addresses
  
  resources :networks do
    member do
      get :addresses
    end
  end
  
  resources :servers_volumes

  resources :volumes do
    member do
      get :attachments
      post :wipe
    end
  end

  resources :servers do
    member do
      get :storage, :network, :console, :debug
      get "console/socket" => 'servers#socket'
      post :start, :pause, :unpause, :suspend, :stop, :reset
    end
  end

  resources :bundles

  root "pages#index"
  get 'boom' => 'pages#boom'

  match 'errors/:status' => 'pages#error', via: :all

end
