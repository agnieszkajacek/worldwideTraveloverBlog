namespace :photos do
  task regenerate: :environment do
    posts = Post.where('published <= ?', Date.today)
    posts.each do |post|
      post.cover = post.cover[:original]
      post.save!
    end
  end
end
