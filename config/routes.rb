# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }

  devise_scope :user do
    authenticated :user do
      root 'home#index', as: :authenticated_root
    end

    unauthenticated :user do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  resources :technical_services, concerns: :paginatable

  resources :billing_exports do
    member do
      get 'download_csv'
      get 'job_status'
      post 'perform'
    end
  end

  namespace :system do
    resources :groups, concerns: :paginatable
    resources :users, concerns: :paginatable
  end
end
