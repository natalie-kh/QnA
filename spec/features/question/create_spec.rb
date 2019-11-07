require 'rails_helper'

feature 'User can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask Question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Question Title'
      fill_in 'Body', with: 'Question Body'
      click_on 'Ask Question'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Question Title'
      expect(page).to have_content 'Question Body'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask Question'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user can not ask a question' do
    visit questions_path

    expect(page).to have_no_link 'Ask Question'
  end
end
