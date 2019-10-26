# frozen_string_literal: true

namespace :photos do
  task regenerate: :environment do
    posts = Post.where('published <= ?', Date.today)
    posts.each do |post|
      next unless post.cover

      post.cover = post.cover[:original]
      post.save!
    end

    photos = Photo.all
    photos.each do |photo|
      next if photo.image.nil? || !photo.valid?

      photo.image = photo.image[:original]
      photo.save!
    end
  end
end
