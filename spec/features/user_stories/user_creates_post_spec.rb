# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User creates post', type: :feature do
  background do
    @category = create(:category)
    @child_category = create(:category, name: 'Wielka Brytania', ancestry: @category.id.to_s)

    user = create(:user, email: 'test@test.com', password: 'fakepassword')
    sign_in_as(user)

    expect(page.current_path).to eq '/'
    page.has_link? 'Nowy post'
    click_link 'Nowy post'
    expect(page.current_path).to eq '/posts/new'
  end

  scenario 'with valid inputs' do
    select @child_category.name, from: 'post_category_id'
    fill_in 'post[title]', with: 'City break - London'
    fill_in 'post[introduction]', with: 'London, city, capital of the United Kingdom.'

    fill_in_editor_field 'Hello London!'
    expect(page).to have_editor_display text: 'Hello London!'

    click_button 'Utwórz'

    post = Post.last

    expect(page.current_path).to eq "/posts/#{post.slug}"
  end

  scenario 'with invalid inputs' do
    fill_in 'post[title]', with: ''
    fill_in 'post[introduction]', with: ''

    fill_in_editor_field ''
    expect(page).to have_editor_display text: ''

    click_button 'Utwórz'

    expect(page).to have_content 'Wybierz kategorię'
    expect(page).to have_content 'Uzupełnij tytuł'
    expect(page).to have_content 'Wpisz wstęp'
    expect(page).to have_content 'Uzupełnij treść posta'
  end

  private

  def fill_in_editor_field(text)
    within '.CodeMirror' do
      # Click makes CodeMirror element active:
      current_scope.click

      # Find the hidden textarea:
      field = current_scope.find('textarea', visible: false)

      # Mimic user typing the text:
      field.send_keys text
    end
  end

  def have_editor_display(options)
    editor_display_locator = '.CodeMirror-code'
    have_css(editor_display_locator, options)
  end
end
