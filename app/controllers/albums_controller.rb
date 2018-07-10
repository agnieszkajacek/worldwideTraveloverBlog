class AlbumsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  
  def show
    @category = Category.friendly.find(params[:id])
    @photos = Photo.where(category_id: @category)
  end
end
