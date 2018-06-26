class CategoriesController < ApplicationController

  def show
    @category = Category.friendly.find(params[:id])
    @posts = Post.where(category_id: @category).order("created_at DESC")
  end
end
