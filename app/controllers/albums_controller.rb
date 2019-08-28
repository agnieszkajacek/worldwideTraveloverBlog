# frozen_string_literal: true

class AlbumsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]

  def show
    @category = Category.friendly.find(params[:id])
    @photos = Photo.where(category_id: @category)

    unless user_signed_in?
      @photos = Photo.where(category_id: @category, public: true)
    end

    @uniq_tags = @photos.map(&:tag).uniq.reject(&:blank?)

    @tags = @uniq_tags.map do |tag|
      {
        tag_name: tag,
        number: @photos.where(tag: tag).count
      }
    end

    @photos = @photos.where(tag: params[:tag]) if params[:tag].present?
  end
end
