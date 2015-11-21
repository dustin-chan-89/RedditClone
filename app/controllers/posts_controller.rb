class PostsController < ApplicationController
  before_action :require_author!, only: [:edit, :update]
  def new
    @post = Post.new
    render :new
  end

  def create
    @post = Post.new(post_params)
    @post.author = current_user
    # @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to post_url(@post)

    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_url(@post)
    else
      flash[:errors] = @post.errors.full_messages
      redirect_to post_url(@post)
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @sub = Sub.find(@post.sub_id)
    if @post.destroy
      redirect_to sub_url(@sub)
    else
      flash[:errors] = @post.errors.full_messages
      redirect_to post_url(@post)
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :content,  :user_id, :sub_id => [])
  end

  def require_author!
    current_post = Post.find(params[:id])
    if current_user != current_post.author
      # flash "You don't own this post"
      # redirect_to posts_url
      render text: "error"
    end
  end
end
