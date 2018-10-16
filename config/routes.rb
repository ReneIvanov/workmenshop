Rails.application.routes.draw do
  
  devise_for :users
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

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  
  root 'shop#index'

  resources :users
  controller :users do
    get 'show' => :show
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
