require 'rails_helper'

feature 'User can sign up', "
  In order to ask questions
  As an guest user
  I'd like to be able to sign up
" do
  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'New user tries to sign up' do
    fill_in 'Email', with: 'new@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Already existing user tries to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password

    click_button 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'New user tries to sign up with wrong password confirmation' do
    fill_in 'Email', with: 'new@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '123456781'

    click_button 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end
