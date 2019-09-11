# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User destroys post', type: :feature do
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

  scenario 'with successfully' do
    expect(page.current_path).to eq '/'
    click_link(post.title, match: :first)

    click_link 'Usuń'

    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content 'Usunięto'

    expect(page.current_path).to eq '/'
    expect(page).not_to have_content post.slug.to_s
  end
end
