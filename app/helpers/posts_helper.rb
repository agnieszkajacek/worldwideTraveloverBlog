# frozen_string_literal: true

module PostsHelper
  def latest_posts
    Post.includes(:category).where('published <= ?', Date.today).order('published DESC').limit(4)
  end
end
