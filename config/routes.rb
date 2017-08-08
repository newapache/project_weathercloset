Rails.application.routes.draw do

  

  devise_for :users
  root 'home#index'
  
  get 'posts/myindex'

  get 'posts/ourindex'
  resources :posts, except: [:show]

end
