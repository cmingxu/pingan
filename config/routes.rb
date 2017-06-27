Rails.application.routes.draw do
  get 'welcome/index'

  resources :logins
  resources :accounts do
    collection do
      post :renew_proxies
    end

    member do
      post :login
      post :renew_proxy
    end
  end
  resources :patients

  get 'welcome/index', as: :dashboard
  root 'welcome#index'
end
