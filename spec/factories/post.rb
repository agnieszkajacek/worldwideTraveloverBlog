FactoryBot.define do
  factory :post do
    title { "Test" }
    content { "Some content" }
    introduction { "Introduction to post" }
    category
  end
end
