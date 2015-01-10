Rails.application.routes.draw do
  
  resources :appliances
  resources :zones
  resources :hosts
  resources :accounts
  resources :storage_pools
  resources :users
  resources :transactions
  resources :tariffs
  resources :addresses_networks
  resources :addresses
  resources :networks
  resources :servers_volumes
  resources :volumes

  resources :servers do
    member do
      get :storage, :network, :console
      post :start, :pause, :unpause, :suspend, :stop
    end
  end

  resources :bundles

  root "pages#index"
  get 'boom' => 'pages#boom'

  match 'errors/:status' => 'pages#error', via: :all

end
