Rails.application.routes.draw do

  concern :votable do
    member { post :vote }
  end

  devise_for :users
  resources :questions, except: [:edit], concerns: [:votable] do
    resources :answers, shallow: true, only: [:create, :destroy, :update], concerns: [:votable] do
      patch :accept, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  resources :my_awards, only: [:index]

  root to: 'questions#index'
end
