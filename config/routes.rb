require 'sidekiq/web'

Rails.application.routes.draw do

  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

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

    resources :subscriptions, only: [:create, :destroy], shallow: true
  end

  resources :attachments, only: [:destroy]

  resources :awards, only: [:index]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index], controller: 'users' do
        get :me, on: :collection
      end

      resources :questions, except: [:new, :edit] do
        resources :answers, except: [:new, :edit], shallow: true
      end
    end
  end

  root to: 'questions#index'
end
