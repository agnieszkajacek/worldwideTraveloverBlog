# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User logs in', type: :feature do
  scenario 'with valid credentials' do
    user = create(:user, email: 'test@test.com', password: 'fakepassword')

    sign_in_as(user)

    expect(page).to have_content 'Pomyślnie zalogowano'
  end

  scenario 'with invalid email' do
    visit '/users/sign_in'
    fill_in 'user[email]', with: 'fake@email.com'
    click_button 'Zaloguj'

    expect(page).to have_content 'Nie znaleziono użytkownika w bazie'
  end

  scenario 'with invalid password' do
    user = create(:user, email: 'test@test.com', password: 'testTest123')

    visit '/users/sign_in'
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: 'fakepassword'
    click_button 'Zaloguj'

    expect(page).to have_content 'Błędne hasło lub email'
  end
end
