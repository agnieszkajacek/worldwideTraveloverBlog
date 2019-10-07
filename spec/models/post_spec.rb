# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post do
  let!(:category) { create(:category) }

  before(:each) do
    @post = build(
      :post,
      title: 'City break - Londyn',
      content: 'To Twoja pierwsza wizyta w tym mieście i nie masz bladego pojęcia, na których atrakcjach się skupić?',
      introduction: 'Londyn - jedna z największych europejskich stolic.',
      category_id: category.id
    )
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(@post).to be_valid
    end

    it 'is invalid without title' do
      @post.title = nil

      expect(@post).not_to be_valid
      expect(@post.errors.messages[:title]).to include('Uzupełnij tytuł')
    end

    it 'is invalid without content' do
      @post.content = nil

      expect(@post).not_to be_valid
      expect(@post.errors.messages[:content]).to include('Uzupełnij treść posta')
    end

    it 'is invalid without introduction' do
      @post.introduction = nil

      expect(@post).not_to be_valid
      expect(@post.errors.messages[:introduction]).to include('Wpisz wstęp')
    end

    it 'is invalid without category' do
      @post.category_id = nil

      expect(@post).not_to be_valid
      expect(@post.errors.messages[:category_id]).to include('Wybierz kategorię')
    end
  end

  describe 'associations' do
    it { should belong_to(:category) }
  end

  describe '#search' do
    it 'returns the search result' do
      @post.save!
      expect(Post.search('City break')).to eq([@post])
    end
  end
end
