# Copyright (c) 2016 Nathan Baum

Rails.application.routes.draw do

  root "pages#index"

  get "status" => 'pages#status'

  resources :scripts

  resources :errors

  resources :jobs do
    collection do
      post :remove_finished
    end
    member do
      post :restart
      post :cancel
    end
  end

  resources :sessions do
    member do
      get :terminate
      post :terminate
    end
  end

  resources :appliances
  resources :zones

  resources :hosts do
    member do
      get :servers
      post :evict_all
    end
  end

  resources :accounts

  resources :storage_pools do
    member do
      get :volumes
      post :refresh
    end
  end

  resources :users do
    member do
      get :password, :jobs
    end
  end

  resources :transactions
  resources :tariffs

  resources :networks do
    collection do
      get :addresses
    end
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
      get :attachments, :upload
      post :wipe
      post :upload, action: :upload!
    end
  end

  resources :servers do
    member do
      get :storage, :network, :console, :debug, :admin, :guest, :scripting
      get "console/socket" => "servers#socket"
      post :start, :pause, :unpause, :suspend, :stop, :reset, :clone, :resume
      post :migrate, :evict, :push, :bootstrap, :unaddress
      post :guest_password, :guest_execute, :script
    end
    resources :server_events
  end

  resources :bundles do
    member do
      post :start, :pause, :unpause, :suspend, :stop, :reset, :clone
    end
  end

  post '/callback/server_event' => "callback#server_event"

  match "errors/:status" => "pages#error", via: :all
end
