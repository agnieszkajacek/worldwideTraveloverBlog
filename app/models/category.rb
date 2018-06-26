class Category < ApplicationRecord
  has_many :posts
  has_many :suncategories
  has_ancestry
end
