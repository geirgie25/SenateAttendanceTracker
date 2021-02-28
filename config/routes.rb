Rails.application.routes.draw do

  root "sessions#new"

  # LOGIN INFORMATION
  resources :accounts, only: [:new, :create]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  # get 'authorized', to: 'sessions#page_requires_login'

  # dashboard routes
  get 'dashboard/admin', to: 'attendance_records#admin_dashboard'
  get 'dashboard/user', to: 'attendance_records#user_dashboard'
  get 'dashboard/admin(/:meeting_id)', to: 'attendance_records#view_meeting'
  post 'dashboard/user/meeting_signin', to: 'attendance_records#sign_into_meeting'
  post 'dashboard/admin/start_meeting', to: 'attendance_records#start_meeting_signin'
  post 'dashboard/admin/end_meeting', to: 'attendance_records#end_meeting_signin'
end
