# frozen_string_literal: true

class PhotosController < ApplicationController
  before_action :find_photo, only: %i[edit update destroy]
  before_action :authenticate_user!, only: %i[new create edit update destroy]

  def index
    find_categories
  end

  def new
    @photo = Photo.new
    find_categories
  end

  def create
    @photo = Photo.new(photo_params)

    if @photo.save
      redirect_to photos_path, notice: 'The photo was created!'
    else
      render 'new'
    end
  end

  def edit
    find_categories
  end

  def update
    @photo.update(photo_params)
    @photo.image = @photo.image[:original] if photo_params[:image].nil?

    if @photo.save
      redirect_to photos_path, notice: 'Update successful!'
    else
      render 'edit'
    end
  end

  def destroy
    @photo.destroy
    redirect_to root_path, notice: 'Photo destroyed'
  end

  private

  def photo_params
    params.require(:photo).permit(:name, :description, :image, :category_id, :crop_x, :crop_y, :crop_width, :crop_height, :tag, :public)
  end

  def find_categories
    @categories = if user_signed_in?
                    Category.all
                  else
                    Category.where(show_in_gallery: true).where.not(ancestry: nil)
                  end
  end

  def find_photo
    @photo = Photo.find(params[:id])
  end
end
