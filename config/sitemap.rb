require 'aws-sdk'
# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host =  "http://worldwide-travelover.com"

SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new(
  ENV['AWS_BUCKET'],
  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  aws_secret_access_key: ENV['AWS_SECRET_KEY_ID'],
  aws_region: ENV['AWS_REGION']
)

SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_host = "http://s3.#{ENV['AWS_REGION']}.amazonaws.com/#{ENV['AWS_BUCKET']}"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  add '/kontakt', :changefreq => 'monthly'
  add '/wspolpraca', :changefreq => 'monthly'

  Category.find_each do |category|
    add category_path(category), :lastmod => category.updated_at
  end
  Post.find_each do |post|
    add post_path(post), :lastmod => post.updated_at
  end
end
