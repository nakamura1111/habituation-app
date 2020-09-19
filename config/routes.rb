Rails.application.routes.draw do
  devise_for :users
  get '/users', to: 'users#retake_registration'
  get '/targets', to: 'targets#new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'targets#index'
  resources :targets, only: [:index, :new, :create]
end
