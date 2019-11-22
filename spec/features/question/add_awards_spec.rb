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
end
