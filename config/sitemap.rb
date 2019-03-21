# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host =  "http://worldwide-travelover.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  add '/kontakt', :changefreq => 'monthly'
  add '/wspolpraca', :changefreq => 'monthly'

  Category.find_each do |category|
    add category_path(category), :lastmod => category.updated_at
  end
  Post.find_each do |post|
    add post_path(post), :lastmod => post.updated_at
  end
  Photo.find_each do |photo|
    add photo_path(photo), :lastmod => photo.updated_at
  end
end

SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
  ENV['AWS_BUCKET'],
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_KEY_ID'],
  aws_region: ENV['AWS_REGION']
)

SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_host = "http://s3.amazonaws.com/<%= ENV['AWS_BUCKET'] %>"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
