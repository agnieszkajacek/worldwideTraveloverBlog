class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @posts = Post.where("published <= ?", Date.today).order("published DESC")
    if params[:search]
      @posts = @posts.search(params[:search])
    end
  end

  def show
    @post = Post.friendly.find(params[:id])
  end

  def new
    @post = Post.new
    find_category
  end

  def create
    @post = Post.new(post_params)
    @subscribers = Subscriber.all

    if @post.save!
      #@subscribers.each do |subscriber|
      #  NotificationMailer.post_email(subscriber.email, @post).deliver_now
      #end
      redirect_to @post, notice: "The post was created!"
    else
      render "new"
    end
  end

  def edit
    find_category
  end

  def update
    @subscribers = Subscriber.all

    if @post.update(post_params)
      #@subscribers.each do |subscriber|
      #  NotificationMailer.post_email(subscriber.email, @post).deliver_now
      #end
      redirect_to @post, notice: "Update successful!"
    else
      render "edit"
    end
  end

  def destroy
     @post.destroy
     redirect_to root_path, notice: "Post destroyed"
  end

  def find_category
    @category = []

    Category.all.each do |category|
      if category.has_children?
        category.children.each do |c|
          @category << c
        end
      end
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, :category_id, :cover, :published, :introduction)
  end

  def find_post
    @post = Post.friendly.find(params[:id])
  end
end
