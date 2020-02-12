Rails.application.routes.draw do

  use_doorkeeper
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

  resources :awards, only: [:index]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: [:show, :index]
    end
  end

  root to: 'questions#index'
end
