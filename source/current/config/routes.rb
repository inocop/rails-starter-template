Rails.application.routes.draw do

  # ログイン・ログアウト以外のdeviseルーティングを制限
  devise_for :users, skip: :all
  devise_scope :user do
    get    'users/sign_in'  => 'devise/sessions#new',     as: :new_user_session
    post   'users/sign_in'  => 'devise/sessions#create',  as: :user_session
    delete 'users/sign_out' => 'devise/sessions#destroy', as: :destroy_user_session
  end

  root 'dashboard#index'
  get 'dashboard', :to => 'dashboard#index'

  post 'api/select_project', :to => 'api#select_project'

  resources :projects
  resources :tickets

  namespace :admin do
    get 'top', :to => 'top#index'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
