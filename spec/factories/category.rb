# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { 'Thailand' }
    show_in_gallery { false }
  end
end
