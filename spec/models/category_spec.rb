# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'validations' do
    it 'is invalid without name' do
      category = Category.create(name: '')

      expect(category).not_to be_valid
      expect(category.errors.details[:name]).to include(error: :blank)
    end

    it 'is valid with name' do
      category = Category.create(name: 'Thailand')

      expect(category).to be_valid
    end
  end

  context 'associations' do
    category = Category.create(name: 'Thailand')

    it 'should have many posts' do
      expect(category).to have_many(:posts)
    end

    it 'should have mamy photos' do
      expect(category).to have_many(:photos)
    end
  end
end
