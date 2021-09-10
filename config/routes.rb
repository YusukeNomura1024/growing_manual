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
    resources :categories, only: [:create, :destroy]
    resources :users, only: [:edit, :show, :update] do
      resources :messages, only: [:create, :index]
    end
    resources :tags, only: [:create, :destroy]
    resources :manuals do
      resource :bookmark, only: [:create, :destroy]
      resources :reviews, only: [:index, :create, :destroy, :update]
      post 'manuals/:id/procedures', to: 'procedures#all_save'
      resources :procedures, only: [:index]
    end
    resources :memos
    resources :memo_links, only: [:index, :create, :destroy]
    resources :notifications, only: :index
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
