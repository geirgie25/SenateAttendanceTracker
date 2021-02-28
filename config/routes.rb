Rails.application.routes.draw do

  # LOGIN INFORMATION
  resources :accounts, only: [:new, :create]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'welcome', to: 'sessions#welcome'
  # get 'authorized', to: 'sessions#page_requires_login'

end
