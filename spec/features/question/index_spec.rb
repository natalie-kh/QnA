require 'rails_helper'

feature 'User can show question list', "
  In order to find answer for a question
  As an authenticated user
  I'd like to be able to show question list
" do
  given!(:questions) { create_list(:question, 3, user: user) }
  given(:user) { create(:user) }

  scenario 'Authenticated user shows question list' do
    sign_in(user)
    visit questions_path

    expect(page).to have_content('MyString', count: 3)

  end
  scenario 'Unauthenticated user shows question list' do
    visit questions_path

    expect(page).to have_content('MyString', count: 3)
  end
end
