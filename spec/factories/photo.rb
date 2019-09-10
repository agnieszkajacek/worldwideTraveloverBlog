# frozen_string_literal: true

FactoryBot.define do
  factory :photo do
    name { 'Test pic' }
    image { Rails.root.join('spec/files/test_pic.jpg').open }
    category
  end
end
