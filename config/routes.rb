Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "attendance_records#index"
  
  get 'dashboard', to: 'attendance_records#index'
  get 'dashboard(/:meeting_id)', to: 'attendance_records#view_meeting'
  post 'dashboard/meeting_signin', to: 'attendance_records#sign_into_meeting'
  post 'dashboard/start_meeting', to: 'attendance_records#start_meeting_signin'
  post 'dashboard/start_meeting', to: 'attendance_records#end_meeting_signin'
end
