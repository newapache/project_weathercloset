class PostsController < ApplicationController
  
  before_action :authenticate_user!
  before_action :check_ownership, only: [:edit, :update, :destroy]
  
  def ourindex
    @posts = Post.all.order('created_at desc') 
  end
  
  def myindex
    @posts = current_user.posts.reverse #현재 사용자의 게시글을 모두 가져온다.
  end
  
  def create
    new_post = Post.new(user_id: current_user.id, content: params[:content], outer: params[:outer], top: params[:top], bottom: params[:bottom], dress: params[:dress], etc: params[:etc])

    new_post.image = params[:image]

    privacy = params[:show_attribute]
    
    if privacy == "1"
      new_post.show_attribute = true
    else
      new_post.show_attribute = false
    end
    
    if new_post.save
      redirect_to '/posts/myindex'
    else
      redirect_to '/posts/myindex'
    end
  end

  def edit
    #@post = Post.find_by(id: params[:id])
  end

  def update
    #@post = Post.find_by(id: params[:id])
    redirect_to root_path if @post.user.id != current_user.id
    
    @post.image = params[:image] unless params[:image].nil?
    
    @post.update_attributes(content: params[:content], outer: params[:outer], top: params[:top], bottom: params[:bottom], dress: params[:dress], etc: params[:etc])
    privacy = params[:show_attribute]
    
    if privacy == "1"
      @post.show_attribute = true
    else
      @post.show_attribute = false
    end
    
    if @post.save
      redirect_to post_path
    else
      render :edit
    end
  end
  
  def show
    @post = Post.find_by(id: params[:id])
  end

  def destroy
    @post.destroy
    redirect_to '/posts/myindex'
  end
  
  def check_ownership 
    @post = Post.find_by(id: params[:id]) 
    redirect_to root_path if @post.user.id != current_user.id 
  end
end