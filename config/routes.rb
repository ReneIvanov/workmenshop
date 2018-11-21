require 'sidekiq/web'
Rails.application.routes.draw do
  
  resources :works
  controller :works do
    get 'registration_new_work' => :registration_new
    post 'registration_create_work' => :registration_create
    get 'registration_edit_work' => :registration_edit
    post 'registration_update_work' => :registration_update
    get 'works/:id/users' => :show_work_users, as: 'work_users'
  end

  resources :accounts
  
  #devise_for :users
  devise_for :users, controllers: { registrations: 'my_devise/registrations', confirmations: 'my_devise/confirmations' }

  #controller :application do
  #  get 'authorize_user' => :authorize_user
  #end

  #controller :anonymous do
  #  get 'aaa' => :aaa
  #end

  controller :loged_user do
    get 'loged_user' => :wellcome
  end

  controller :loged_admin do
    get 'loged_admin' => :wellcome
  end

  #controller :sessions do
    #get 'login' => :new
    #post 'login' => :create
    #delete 'logout' => :destroy
  #end

  resources :users
  controller :users do
    get 'users/:id/pictures' => :pictures_show, as: 'show_users_pictures'
    patch 'users/:id/pictures' => :pictures_update, as: 'update_users_pictures'
    get 'users/:id/works' => :show_user_works, as: 'user_works'
  end

  root 'shop#index'

  
  #controller :users do
  #  get 'show' => :show
  #end

  mount Sidekiq::Web => '/sidekiq'

end
