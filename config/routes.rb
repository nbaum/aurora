Rails.application.routes.draw do

  resources :sessions do
    member do
      get :terminate
      post :terminate
    end
  end

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

  resources :users do
    member do
      get :password
    end
  end

  resources :transactions
  resources :tariffs

  resources :networks do
    member do
      post :upgrade
    end
    resources :subnets do
      resources :addresses
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
      post :start, :pause, :unpause, :suspend, :stop, :reset, :clone, :resume
    end
  end

  resources :bundles do
    member do
      post :start, :pause, :unpause, :suspend, :stop, :reset, :clone
    end
  end

  root "pages#index"
  get 'boom' => 'pages#boom'

  match 'errors/:status' => 'pages#error', via: :all

end
