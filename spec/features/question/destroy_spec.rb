require 'rails_helper'

feature 'Qiestion owner User can destroy the question', "
  In order to destroy question from a community
  As an authenticated user
  I'd like to be able to delete the question
" do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user)}

  describe 'Authenticated user' do
    scenario 'deletes his question' do
      sign_in(user)

      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'Your question successfully deleted.'
      expect(page).have_current_path questions_path
    end

    scenario "deletes another user's question" do
      sign_in(user2)

      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'You are not authorized for this.'
      expect(page).have_current_path questions_path
    end
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
