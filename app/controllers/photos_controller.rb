class PhotosController < ApplicationController
  before_action :find_photo, only: [:show, :edit, :update, :destroy]

  def index
    @photos = Photo.all.order("created_at DESC")
  end

  def show
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)

    if @photo.save!
      redirect_to @photo, notice: "The photo was created!"
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @photo.update(photo_params)
      redirect_to @photo, notice: "Update successful!"
    else
      render "edit"
    end
  end

  def destroy
     @photo.destroy
     redirect_to root_path, notice: "Photo destroyed"
  end

  private
  def photo_params
    params.require(:photo).permit(:name, :description)
  end

  def find_photo
    @photo = Photo.find(params[:id])
  end
end