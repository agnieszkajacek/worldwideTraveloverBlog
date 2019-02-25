class AlbumsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  
  def show
    @category = Category.friendly.find(params[:id])
    @photos = Photo.where(category_id: @category, public: true)
    @uniq_tags = @photos.map { |photo|  photo.tag}.uniq.reject(&:blank?)

    @tags = @uniq_tags.map do |tag|
      {
        tag_name: tag,
        number: @photos.where(tag: tag).count
      }
    end

    if params[:tag].present?
      @photos = @photos.where(tag: params[:tag])
    end
    
  end
end
