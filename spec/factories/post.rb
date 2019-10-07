# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { 'City break - London' }
    content { 'Hello London!' }
    introduction { 'London, city, capital of the United Kingdom.' }
    category
    cover { Rails.root.join('spec/files/test_pic.jpg').open }
    published { Time.zone.now }
  end
end
