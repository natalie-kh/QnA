require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Unauthenticated user can not to edit answer' do
    visit question_path(question)


    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in author
      visit question_path(question)

      click_on 'Edit'
      within '.answers' do
        fill_in 'Body', with: 'Edited answer body'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in author
      visit question_path(question)

      click_on 'Edit'
      within '.answers' do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's answer", js: true do
      sign_in user
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
