Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'targets#index'
  resources :targets, only: [:index, :new, :create, :show] do
    resources :habits, only: [:new, :create]
  end
  resources :habits_achieved_statuses, only: [:index, :update]
  # 再読み込みが発生した際の処理
  get '/users', to: 'users#retake_registration'
  get '/targets/:target_id/habits', to: 'habits#new'
end
