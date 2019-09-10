# frozen_string_literal: true

module FeaturesSupport
  def sign_in_as(user)
    visit '/users/sign_in'

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password

    click_button 'Zaloguj'
  end
end
