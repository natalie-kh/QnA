require 'rails_helper'

feature 'Question owner can accept answer', "
  In order to mark the best answer
  As an question author
  I'd like to be able to accept the answer
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:accepted_answer) { create(:answer, question: question, user: user, accepted: true) }
  given(:answer_list) { create_list(:answer, 2, question: question, user: user) }

  describe 'Authenticated user' do
    given!(:answer) { create(:answer, question: question, user: user) }

    scenario 'accepts an answer to his question', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'Accept answer'

      expect(page).to (have_content 'Answer successfully accepted.', wait: 5)
      expect(page).to have_no_link 'Accept answer'
    end

    scenario 'accepts another answer to his question', js: true do
      accepted_answer
      sign_in(author)
      visit question_path(question)

      within ".card.answer-#{accepted_answer.id}" do
        expect(page).to have_no_link 'Accept answer'
      end

      within ".card.answer-#{answer.id}" do
        expect(page).to have_link 'Accept answer'
        click_on 'Accept answer'
      end

      expect(page).to (have_content 'Answer successfully accepted.', wait: 5)

      within ".card.answer-#{answer.id}" do
        expect(page).to have_no_link 'Accept answer'
      end
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

  scenario 'Accepted answer renders first in list' do
   answer_list
   accepted_answer
   visit question_path(question)

    within '.answers' do
      answers = page.all(:css, '.card .card')
      expect(answers.first.find_css(".answer-#{accepted_answer.id}")).not_to be_empty
      expect(answers.first.find_css(".answer-#{answer_list.first.id}")).to be_empty
    end
  end
end
