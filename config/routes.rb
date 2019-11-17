Rails.application.routes.draw do

  devise_for :users
  resources :questions, except: [:edit] do
    resources :answers, shallow: true, only: [:create, :destroy, :update] do
      patch :accept, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  root to: 'questions#index'
end
