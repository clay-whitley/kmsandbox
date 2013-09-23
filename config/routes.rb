Kmsandbox::Application.routes.draw do
  devise_for :users
  root to: 'products#index'

  resources :products

end
