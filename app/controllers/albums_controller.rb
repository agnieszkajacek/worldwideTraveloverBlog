class AlbumsController < ApplicationController
  def show
    @category = Category.friendly.find(params[:id])
    @photos = Photo.where(category_id: @category)
  end
end
