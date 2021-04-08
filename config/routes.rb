# frozen_string_literal: true

Rails.application.routes.draw do
  root 'sessions#new'

  # LOGIN INFORMATION
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  post 'logout', to: 'sessions#destroy'
  # get 'authorized', to: 'sessions#page_requires_login'

  # dashboard routes
  resources :dashboards, :only => [] do
    collection do
      get 'user'
      get 'admin'
    end
  end

  resources :attendance_records, :only => [:index]

  # committees route
  resources :committees, :only => [:new, :create, :show, :edit, :update] do
    resources :users, :only => [:index, :show]
    resources :meetings, :only => [:index]
    resources :excuses, :only => [:index, :show, :edit, :update, :destroy]
  end

  # meetings route
  resources :meetings, :only => [:index,:create, :show] do
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
  resources :excuses, :only => [:show, :new, :create, :update, :destroy]

end
