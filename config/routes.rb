# frozen_string_literal: true

Rails.application.routes.draw do
  root 'sessions#new'

  # LOGIN INFORMATION
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  post 'logout', to: 'sessions#destroy'
  # get 'authorized', to: 'sessions#page_requires_login'

  get 'help', to: 'dashboards#help'
  # dashboard routes
  resources :dashboards, :only => [] do
    collection do
      get 'user'
      get 'admin'
    end
  end

  get "dashboards/admin/download_records", to: 'dashboards#download_session'
  get "/dashboards/admin/delete_records", to: 'dashboards#delete_records'
  

  resources :attendance_records, :only => [:index]

  # committees route
  resources :committees, :only => [:new, :create, :show, :edit, :update, :destroy]

  # meetings route
  resources :meetings, :only => [:index, :create, :show] do
    member do
      post :end
      post :sign_in
    end
  end

  # meetings
  post 'meeting/new', to: 'meetings#create'

  # users routes
  resources :users

  # excuses routes
  get 'excuses/my_absences', to: 'excuses#my_absences'
  resources :excuses

end
