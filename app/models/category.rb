class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  has_many :posts
  has_many :subcategories
  has_ancestry
end
