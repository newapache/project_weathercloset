Rails.application.routes.draw do

  devise_for :users

  root 'home#index'
  
  get 'posts/myindex'

  get 'posts/ourindex'
  
  
  # resources :posts, except: [:show]
  post '/posts/create' => 'posts#create' 
  post '/posts/myindex' => 'posts#myindex'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get 'home/index'
  get 'home/weather'
  get 'home/setting'
  
  resources 'posts' do
    post "/like", to: "likes#like_toggle"
  
  # post '/posts/show/:post_id/comments/create' => 'comments#create'
  # post '/posts/show/:post_id/comments/destroy/:comment_id' => 'comments#destroy'
  end
end
