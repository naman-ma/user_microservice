Rails.application.routes.draw do
  post '/signup', to: 'users#create'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/verify_token', to: 'users#verify_token'
  
  resources :users, only: [:update, :destroy]

  get "up" => "rails/health#show", as: :rails_health_check

end
