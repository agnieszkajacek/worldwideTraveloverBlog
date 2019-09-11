# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User updates post', type: :feature do
  given!(:category) { create(:category, name: 'Europe') }
  given!(:child_category) { create(:category, name: 'United Kingdom', ancestry: category.id.to_s) }
  given!(:photo) { create(:photo, category: child_category) }
  given!(:post) do
    create(
      :post,
      category_id: child_category.id
    )
  end

  background do
    user = create(:user, email: 'test@test.com', password: 'fakepassword')
    sign_in_as(user)
  end

  scenario 'with valid inputs' do
    expect(page.current_path).to eq '/'
    click_link(post.title, match: :first)

    click_link 'Edytuj'

    expect(page.current_path).to eq "/posts/#{post.slug}/edit"

    fill_in 'post[title]', with: '3 days in London'
    click_button 'Zaktualizuj'

    expect(page.current_path).to eq "/posts/#{post.slug}"
    expect(page).to have_content 'Zaktualizowano'
  end
end
