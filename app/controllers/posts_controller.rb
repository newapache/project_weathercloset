class PostsController < ApplicationController
  
  before_action :authenticate_user!
  before_action :check_ownership, only: [:edit, :update, :destroy]
  
  def ourindex
    @posts = Post.all.order('created_at desc') 
  end
  
  def myindex
    @posts = current_user.posts #현재 사용자의 게시글을 모두 가져온다.
  end
  
  def create
    new_post = Post.new(user_id: current_user.id, content: params[:content], outer: params[:outer], top: params[:top], bottom: params[:bottom], dress: params[:dress], etc: params[:etc])
    privacy = params[:show_attribute]
    
    if privacy == "1"
      new_post.show_attribute = true
    else
      new_post.show_attribute = false
    end
    
    if new_post.save
      redirect_to '/posts/myindex'
    else
      redirect_to new_post_path
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    redirect_to root_path if @post.user.id != current_user.id
    
    @post.content = params[:content]
    @post.image = params[:image] if params[:image].present?
    
    if @post.save
      redirect_to '/posts/ourindex'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to '/posts/ourindex'
  end
  
  def check_ownership 
    @post = Post.find_by(id: params[:id]) 
    redirect_to root_path if @post.user.id != current_user.id 
  end
end
