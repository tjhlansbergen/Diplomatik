Rails.application.routes.draw do
  resources :admin_users, only: [:new, :create]
  get 'admin_login', to: 'admin_sessions#new'
  post 'admin_login', to: 'admin_sessions#create'
  get 'admin_logout', to: 'admin_sessions#admin_logout'
  get 'overview', to: 'admin#overview'
  
  root 'admin#overview'
end
