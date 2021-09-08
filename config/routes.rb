Rails.application.routes.draw do

  scope module: :public do
    root "homes#top"
    get "about", to: 'homes#about'
    get 'users/:id/unsubscribe', to: 'users#unsubscribe'
    patch 'users/:id/withdraw', to: 'users#withdraw'
    resources :categories, only: [:create, :destroy]
    resources :users, only: [:edit, :show, :update] do
      resources :messages, only: [:create, :index]
    end
    resources :manuals do
      resource :bookmark, only: [:create, :destroy]
      resources :reviews, only: [:index, :create, :destroy, :update]
      resources :tags, only: [:create, :destroy]
      post 'manuals/:id/procedures', to: 'procedures#all_save'
      resources :procedures, only: [:index]
    end
    resources :memos
    resources :memo_links, only: [:index, :create, :destroy]
  end

  devise_for :users, controllers: {
      sessions: 'public/sessions',
      registrations: 'public/registrations',
      passwords: 'public/passwords'
    }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
