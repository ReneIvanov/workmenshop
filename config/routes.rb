Rails.application.routes.draw do
  
  controller :loged_user do
    get 'loged_user' => :wellcome
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  
  root 'shop#index'

  resources :people

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
