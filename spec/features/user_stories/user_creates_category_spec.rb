# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User creates category', type: :feature do
  given!(:parent_category) { create(:category) }

  background do
    user = create(:user, email: 'test@test.com', password: 'fakepassword')
    sign_in_as(user)

    expect(page.current_path).to eq '/'
    click_link 'Nowa kategoria'

    expect(page.current_path).to eq '/categories/new'
  end

  feature 'create main category' do
    scenario 'with valid inputs' do
      fill_in 'category[name]', with: 'Azja'
      click_button 'Utwórz kategorię'

      expect(page.current_path).to eq '/categories'
      expect(page).to have_content 'Utworzono'
    end

    scenario 'with invalid inputs' do
      fill_in 'category[name]', with: ''
      click_button 'Utwórz kategorię'

      expect(page).to have_content 'To pole nie może być puste'
    end
  end

  feature 'create subcategory' do
    scenario 'with valid inputs' do
      fill_in 'category[name]', with: 'Azja'
      select parent_category.name, from: 'category_parent_id'

      click_button 'Utwórz kategorię'

      expect(page.current_path).to eq '/categories'
      expect(page).to have_content 'Utworzono'
    end
  end
end
