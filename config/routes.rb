Rails.application.routes.draw do
  
  root 'shop#index'

  resources :people

  controller :people do
    get 'picture' => :picture
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
