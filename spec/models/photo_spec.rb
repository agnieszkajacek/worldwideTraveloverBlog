# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Photo, type: :model do
  let!(:category) { create(:category) }

  context 'validations' do
    it 'is valid with name and category_id' do
      photo = Photo.create(name: 'test', category_id: category.id)

      expect(photo).to be_valid
    end

    it 'is invalid without name' do
      photo = Photo.create(name: nil, category_id: category.id)

      expect(photo).not_to be_valid
      expect(photo.errors.details[:name]).to include(error: :blank)
    end

    it 'is invalid without category_id' do
      photo = Photo.create(name: nil, category_id: nil)

      expect(photo).not_to be_valid
      expect(photo.errors.details[:category_id]).to include(error: :blank)
    end
  end

  context 'associations' do
    it { should belong_to(:category) }
  end
end
