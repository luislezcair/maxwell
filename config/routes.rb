# frozen_string_literal: true

require 'sidekiq/web'

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

  resources :accounts

  resources :billing_exports do
    member do
      get 'job_status'
      post 'perform'
    end
  end

  resources :clients, concerns: :paginatable do
    collection do
      get 'search', defaults: { format: :json }
    end
  end

  resources :invoices, concerns: :paginatable, only: [:index, :show] do
    collection do
      get 'download'
    end

    member do
      post 'perform_sync'
      get 'job_status'
    end
  end

  resources :technical_services, concerns: :paginatable do
    collection do
      get 'download'
    end
  end

  namespace :system do
    resources :groups, concerns: :paginatable
    resources :users, concerns: :paginatable

    post 'ucrm_webhooks', to: 'ucrm_webhooks#incoming',
                          defaults: { format: :json }
  end

  authenticate :user, ->(u) { u.group.admin? } do
    mount Sidekiq::Web => '/system/sidekiq'
  end

  namespace :elements do
    resources :corporate_cellphones, concerns: :paginatable, except: [:show]
    resources :technicians, concerns: :paginatable, except: [:show]
    resources :work_types, concerns: :paginatable, except: [:show]
  end
end
