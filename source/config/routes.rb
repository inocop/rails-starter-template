Rails.application.routes.draw do

  devise_for :users

  root 'dashboard#index'
  get 'dashboard', :to => 'dashboard#index'

  post 'auth/switch_project', :to => 'auth#switch_project'

  resources :projects

  namespace :admin do
    get 'top', :to => 'top#index'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
