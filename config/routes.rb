Rails.application.routes.draw do
  devise_for :users, controllers: {
      sessions: 'public/sessions',
      registrations: 'public/registrations',
      passwords: 'public/passwords'
    }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :admin do
    root "homes#top"
    get 'manuals/search'    , to: 'manuals#search', as: 'search_manual'
    get 'messages', to: 'homes#messages', as: 'messages'
    resources :tags, only: [:show]
    resources :users do
      resources :messages, only: [:index, :update, :create, :destroy]
    end
    resources :manuals do
      resources :reviews, only: [:index, :destroy]
      resources :procedures, only: [:index]
    end
    resources :reviews, only: [:show]
    resources :memo_links   , only: [:show]
  end

  scope module: :public do
    root  "homes#top"
    get   "about"                 , to: 'homes#about'
    get   'users/:id/password_edit', to: 'users#password_edit', as: 'user_password_edit'
    patch 'users/:id/password_reset', to: 'users#password_reset', as: 'user_password_reset'
    get   'users/:id/unsubscribe' , to: 'users#unsubscribe' , as: 'user_unsubscribe'
    patch 'users/:id/withdraw'    , to: 'users#withdraw'    , as: 'user_withdraw'
    resources :categories         , only: [:create, :destroy, :show, :index, :new]
    resources :users              , only: [:edit, :show, :update] do
      resources :messages         , only: [:create, :index, :new]
      resources :notifications    , only: :index
    end
    resources :tags         , only: [:create, :destroy, :show]
    patch 'manuals/:id/sort', to: 'manuals#sort'
    get 'manuals/search'    , to: 'manuals#search', as: 'search_manual'
    resources :manuals do
      resource :bookmark    , only: [:create, :destroy]
      resources :reviews    , only: [:index, :create, :destroy, :update, :edit, :new]
      resources :procedures , only: [:index, :create, :destroy, :edit, :update]
    end
    get 'procedures/:id/memo_links/new'           , to: 'memo_links#new', as: 'new_procedure_memo_link'
    get 'procedures/:id/memo_links/search'        , to: 'memo_links#search', as: 'search_procedure_memo_link'
    get 'procedures/:procedure_id/memos/:id/link' , to: 'memos#link'    , as: 'link_procedure_memo'
    get 'memos/search'                            , to: 'memos#search'  , as: 'search_memo'
    resources :memos do
      resources :memo_links , only: [:index]
    end
    resources :memo_links   , only: [:index, :destroy, :create, :show]

  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
