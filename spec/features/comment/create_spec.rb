require 'rails_helper'

feature 'User can create answers for a question', "
  In order to clarify answers or questions
  As an authenticated user
  I'd like to be able to write comments
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
      expect(page).to have_no_css('.question .comments', text: 'First Comment')
    end

    scenario 'create comment for the question', js: true do
      fill_in 'comment_body', with: 'First Comment'
      click_on 'Post the Comment'

      expect(page).to have_content 'Your comment successfully created.'
      expect(page).to have_css('.question .comments', text: 'First Comment')
    end

    scenario 'creates comment with errors', js: true do
      click_on 'Post the Comment'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to comment a question', js: true do
    visit question_path(question)

    expect(page).to have_no_button 'Post the Comment'
  end
end
