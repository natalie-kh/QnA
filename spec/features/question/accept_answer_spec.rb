require 'rails_helper'

feature 'Question owner can accept answer', "
  In order to mark the best answer
  As an question author
  I'd like to be able to accept the answer
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:answers) { create_list(:answer, 3, user: user) }

  describe 'Authenticated user' do
    given!(:answer) { create(:answer, question: question, user: user) }

    scenario 'accepts an answer to his question', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'Accept answer'

      expect(page).to (have_content 'Answer successfully accepted.', wait: 5)
    end

    scenario "accepts an answer to another user's question" do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_no_link 'Accept answer'
    end
  end

  scenario 'Unauthenticated user tries to accept an answer' do
    visit question_path(question)

    expect(page).to have_no_link 'Accept answer'
  end
end
