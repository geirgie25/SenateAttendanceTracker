# frozen_string_literal: true

Rails.application.routes.draw do
  root 'sessions#new'

  # LOGIN INFORMATION
  resources :accounts, only: %i[new create destroy]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  post 'logout', to: 'sessions#destroy'
  # get 'authorized', to: 'sessions#page_requires_login'

  # dashboard routes
  get 'dashboard/admin', to: 'attendance_records#admin_dashboard'
  get 'dashboard/user', to: 'attendance_records#user_dashboard'
  get 'dashboard/general'. to 'committees#index_committee'
  get 'dashboard/general'. to 'committees#delete_committee'
  get 'dashboard/general'. to 'committees#edit_committee'
  get 'dashboard/general'. to 'committees#new_committee'
  get 'dashboard/general'. to 'committees#show_committee'
  get 'dashboard/admin(/:meeting_id)', to: 'attendance_records#view_meeting'
  post 'dashboard/user/meeting_signin', to: 'attendance_records#sign_in'
  post 'dashboard/admin/start_meeting', to: 'attendance_records#start_signin'
  post 'dashboard/admin/end_meeting', to: 'attendance_records#end_signin'

  resources :users
end
