require 'rails_helper'

feature 'Question owner can destroy the question', "
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
      expect(current_path).to eq questions_path
    end

    scenario "deletes another user's question" do
      sign_in(user2)
      visit question_path(question)

      expect(page).to have_no_content 'Delete'
    end
  end

  scenario 'Unauthenticated user tries to delete a question' do
    visit question_path(question)

    expect(page).to have_no_content 'Delete'
  end
end
