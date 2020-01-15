# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :find_category, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[index new create edit update destroy]

  def index
    @categories = Category.all.order('created_at DESC')
  end

  def show
    @category = Category.friendly.find(params[:id])
    scope = Post.includes(:category).where(category_id: @category).order('created_at DESC')
    scope = scope.search_for(params[:search]) if params[:search]

    @posts = scope
  end

  def new
    parent_category
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: t('notice.created')
    else
      parent_category
      render 'new'
    end
  end

  def edit
    parent_category
  end

  def update
    if @category.update(category_params)
      redirect_to @category, notice: t('notice.updated')
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to root_path, notice: t('notice.destroyed')
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id, :cover, :show_in_gallery)
  end

  def find_category
    @category = Category.friendly.find(params[:id])
  end

  def parent_category
    @parent_category = Category.where(ancestry: nil)
  end
end
