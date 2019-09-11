# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User logs out', type: :feature do
  background do
    user = create(:user, email: 'test@test.com', password: 'fakepassword')
    sign_in_as(user)
  end

  scenario 'user logs out' do
    page.has_link? 'Wyloguj się'
    click_link 'Wyloguj się'
    expect(page).to have_content 'Wylogowano poprawnie'
  end
end
