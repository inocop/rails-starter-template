Rails.application.routes.draw do

  devise_for :users
  # devise_scope :user do
  #   get '/users/sign_out' => 'devise/sessions#destroy'
  # end

  root 'dashboard#index'
  get 'dashboard/index'
  get 'dashboard', :to => 'dashboard#index'

  post 'auth/switch_project', :to => 'auth#switch_project'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
