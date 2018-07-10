class CategoriesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  
  def show
    @category = Category.friendly.find(params[:id])
    @posts = Post.where(category_id: @category).order("created_at DESC")
  end
end
