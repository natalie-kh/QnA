require 'rails_helper'

feature 'User can create answers for a question', "
  In order to set answer for community
  As an authenticated user
  I'd like to be able to write answers to questions
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'answer_body', with: 'Answer Body'
      click_on 'Answer the Question'


      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Answer Body'
    end

    scenario 'creates answer with errors' do
      click_on 'Answer the Question'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)
    click_on 'Answer the Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
