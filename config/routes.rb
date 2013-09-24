Kmsandbox::Application.routes.draw do
  resources :widgets

  devise_for :users
  root to: 'pages#home'

  resources :products

end
