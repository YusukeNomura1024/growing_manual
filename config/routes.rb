Rails.application.routes.draw do
  devise_for :users, controllers: {
      sessions: 'public/sessions',
      registrations: 'public/registrations',
      passwords: 'public/passwords'
    }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  scope module: :public do
    root "homes#top"
    get "about", to: 'homes#about'
    get 'users/:id/unsubscribe', to: 'users#unsubscribe', as: 'user_unsubscribe'
    patch 'users/:id/withdraw', to: 'users#withdraw', as: 'user_withdraw'
    resources :categories, only: [:create, :destroy, :show, :index]
    resources :users, only: [:edit, :show, :update] do
      resources :messages, only: [:create, :index]
    end
    resources :tags, only: [:create, :destroy, :show]
    patch 'manuals/:id/sort', to: 'manuals#sort'
    get 'manuals/search', to: 'manuals#search', as: 'search_manual'
    resources :manuals do
      resource :bookmark, only: [:create, :destroy]
      resources :reviews, only: [:index, :create, :destroy, :update, :edit, :new]
      resources :procedures, only: [:index, :create, :destroy, :edit, :update]
    end
    get 'procedures/:id/memo_links/new', to: 'memo_links#new', as: 'new_procedure_memo_link'
    get 'procedures/:procedure_id/memos/:id/link', to: 'memos#link', as: 'link_procedure_memo'
    get 'memos/search', to: 'memos#search', as: 'search_memo'
    resources :memos
    resources :memo_links, only: [:index, :destroy, :create]
    resources :notifications, only: :index
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
