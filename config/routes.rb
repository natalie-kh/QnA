Rails.application.routes.draw do

  devise_for :users
  resources :questions do
    resources :answers, shallow: true, only: [:create, :destroy, :update]
  end

  root to: 'questions#index'
end
