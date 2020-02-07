Rails.application.routes.draw do

  concern :votable do
    member { post :vote }
  end

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  resources :questions, except: [:edit], concerns: [:votable, :commentable] do
    resources :answers, shallow: true, only: [:create, :destroy, :update], concerns: [:votable, :commentable] do
      patch :accept, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  resources :my_awards, only: [:index]

  root to: 'questions#index'
end
