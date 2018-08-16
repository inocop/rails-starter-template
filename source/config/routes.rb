Rails.application.routes.draw do

  devise_for :users
  root 'top#index'

  get 'top/index'
  get 'top', :to => 'top#index', :as => :user_root

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
