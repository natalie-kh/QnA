require 'rails_helper'

feature 'User can log out', "
  In order to destroy session
  As an authenticated user
  I'd like to be able to sign out
" do
  given(:user) { create(:user) }

  scenario 'Authorized user tries to sign out' do
    sign_in(user)
    click_on 'Log Out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthorized user can not to sign out' do
    visit root_path

    expect(page).to have_no_link 'Log Out'
  end
end
