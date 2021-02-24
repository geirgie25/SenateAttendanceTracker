Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "attendance_records#index"
  
  get 'dashboard', to: 'attendance_records#index'
  get 'dashboard(/:meeting_id)', to: 'attendance_records#view_meeting'
end
