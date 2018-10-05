Rails.application.routes.draw do

  root 'dashboard#index'
  get 'dashboard', :to => 'dashboard#index'

  #devise_for :users, :controllers => { :registrations => 'users/registrations' }

  # === deviseのルーティング制限
  # userの更新・削除はprofile_controllerで行うので、registrationsでは新規作成のみ許可
  devise_for :users, skip: [:registrations]
  devise_scope :user do
    get  'users/registrations' => 'users/registrations#new',    as: :new_user_registration
    post 'users/registrations' => 'users/registrations#create', as: :user_registration
  end

  namespace :users do
    get  'profile/edit', :to => 'profile#edit'
    post 'profile/edit', :to => 'profile#update'
    get  'profile/edit_password', :to => 'profile#edit_password'
    post 'profile/edit_password', :to => 'profile#update_password'
  end

  post 'api/select_project', :to => 'api#select_project'

  resources :projects
  resources :tickets

  namespace :admin do
    get 'top', :to => 'top#index'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
