Rails.application.routes.draw do
  
  resources :works
  controller :works do
    get 'registration_new_work' => :registration_new
    post 'registration_create_work' => :registration_create
    get 'registration_edit_work' => :registration_edit
    post 'registration_update_work' => :registration_update
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
  root 'shop#index'

  
  #controller :users do
  #  get 'show' => :show
  #end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
