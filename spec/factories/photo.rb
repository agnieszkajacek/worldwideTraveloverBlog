FactoryBot.define do
  factory :photo do
    name { "Photo name" }
    description { "Some description here"}
    category
    public { true }
  end
end
