Rails.application.routes.draw do
  resources :admin_customers
  resources :admin_users
  resources :admin_api_users
  resources :api_users, path: 'api/users'
  resources :api_qualifications, path: 'api/qualifications'
  resources :api_courses, path: 'api/courses'
  resources :api_students, path: 'api/students'
  
  post "/api/login", to: "api_sessions#login"
  
  get 'admin_login', to: 'admin_sessions#new'
  post 'admin_login', to: 'admin_sessions#create'
  get 'admin_logout', to: 'admin_sessions#admin_logout'
  
  get 'overview', to: 'admin#overview'

  root 'admin#overview'

  # linkedin
  get '/auth/linkedin/callback', to: 'oauth#callback', as: 'oauth_callback'
  get '/auth/linkedin', to: 'oauth#failure', as: 'oauth_failure'
end
