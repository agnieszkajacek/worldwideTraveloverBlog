# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User resets password', type: :feature do
  background do
    @user = create(:user, email: 'test@test.com', password: 'fakepassword')

    visit '/users/sign_in'
    click_link 'Zapomniałeś hasła?'
    expect(page.current_path).to eq '/users/password/new'
  end

  scenario 'when user\'s email exist in database' do
    fill_in 'user[email]', with: @user.email

    click_button 'Wyślij mi instrukcje resetowania hasła'

    expect(page.current_path).to eq '/users/sign_in'
    expect(page).to have_content 'Wysłano instrukcje resetowania hasła'
  end

  scenario 'when user\'s email does not exit in database' do
    fill_in 'user[email]', with: 'fake@email.com'

    click_button 'Wyślij mi instrukcje resetowania hasła'

    expect(page).to have_content 'Podany email nie istnieje w bazie'
  end
end
