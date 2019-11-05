Rails.application.routes.draw do

  devise_for :users
  resources :questions do
    resources :answers, shallow: true, only: [:new, :create]
  end

  root to: 'questions#index'
end
