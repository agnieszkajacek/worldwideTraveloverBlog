class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @posts = Post.includes(:category).where("published <= ?", Date.today).order("published DESC").paginate(:page => params[:page], :per_page => 10)

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
      scheduled_time = Time.zone.now
      @subscribers.each do |subscriber|
        if subscriber.subscription
          NotificationMailer.post_email(subscriber, @post).deliver_later(wait_until: scheduled_time)
        end

        scheduled_time = scheduled_time + 15.minutes
      end
      redirect_to @post
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
    params.require(:post).permit(:title, :content, :category_id, :cover, :published, :introduction, :crop_x, :crop_y, :crop_width, :crop_height)
  end

  def find_post
    @post = Post.friendly.find(params[:id])
  end
end
