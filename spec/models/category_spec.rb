# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  let!(:category) { build(:category, name: 'Category name') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(category).to be_valid
    end

    it 'is invalid without name' do
      category = build(:category, name: nil)

      expect(category).not_to be_valid
      expect(category.errors.details[:name]).to include(error: :blank)
    end
  end

  describe 'associations' do
    it 'should have many posts' do
      expect(category).to have_many(:posts)
    end

    it 'should have mamy photos' do
      expect(category).to have_many(:photos)
    end
  end
end
