# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Photo, type: :model do
  let!(:category) { create(:category) }

  before(:each) do
    @photo = build(
      :photo,
      name: 'Photo name',
      category_id: category.id
    )
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(@photo).to be_valid
    end

    it 'is invalid without name' do
      @photo.name = nil

      expect(@photo).not_to be_valid
      expect(@photo.errors.details[:name]).to include(error: :blank)
    end

    it 'is invalid without category_id' do
      @photo.category_id = nil

      expect(@photo).not_to be_valid
      expect(@photo.errors.details[:category_id]).to include(error: :blank)
    end
  end

  describe 'associations' do
    it { should belong_to(:category) }
  end
end
