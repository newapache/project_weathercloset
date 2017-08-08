class PostsController < ApplicationController
  def create
    @post = Post.new
    @post.content = params[:input_content]
    @post.image = params[:image]
    @post.save
    redirect_to '/posts/myindex'
  end

  def edit
    @post = Post.find(params[:post_id])
  end

  def update
    @post = Post.find(params[:post_id])
    @post.image = params[:image]
    @post.content = params[:input_content]
    @post.save  
    redirect_to '/posts/myindex'
  end

  def myindex
    @posts = Post.all
  end

  def show
  end

  def ourindex
    @posts = Post.all
  end

  def destroy
    @post = Post.find(params[:post_id])
    @post.destroy
    redirect_to '/posts/myindex'
  end
end
