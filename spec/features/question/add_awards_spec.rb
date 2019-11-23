require 'rails_helper'

feature 'User can add award to question', "
  In order to award for best answer to my question
  As an question's author
  I'd like to be able to add award to my question
" do
  given(:author) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(author)

      visit new_question_path

      fill_in 'Title', with: 'Question Title'
      fill_in 'Body', with: 'Question Body'
    end

    scenario 'adds award when asks a question', js: true do

      within '.award' do
        fill_in 'Award name', with: 'Best answer award'
        attach_file 'Award image', "#{Rails.root}/spec/fixtures/files/image.jpg"
      end

      click_on 'Ask Question'

      expect(page).to have_link 'Best answer award'
    end
  end

  describe 'Question author' do
    given(:author) { create(:user) }
    given(:user) { create(:user) }
    given!(:question) { create(:question, user: author) }
    given!(:award) { create(:award, question: question) }
    given!(:answer1) { create(:answer, question: question, user: user) }

    scenario 'rewards accepted answer author', js: true do
      sign_in(author)
      visit question_path(question)

      within ".card.answer-#{answer1.id}" do
        click_on 'Accept answer'
      end

      log_out

      sign_in(user)
      visit my_awards_path(user)

      expect(page).to have_content award.name
      expect(page).to have_content award.question.title
    end
  end
end
