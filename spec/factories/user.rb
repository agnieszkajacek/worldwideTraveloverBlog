# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'test@test' }
    password { '12345678' }
  end
end
