Rails.application.routes.draw do

  scope module: :public do
    root "homes#top"
    get "about", to: 'homes#about'
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
