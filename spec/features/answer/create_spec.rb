require 'rails_helper'

feature 'User can create answers for a question', "
  In order to set answer for community
  As an authenticated user
  I'd like to be able to write answers to questions
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answers the question', js: true do
      fill_in 'answer_body', with: 'Answer Body'
      click_on 'Answer the Question'


      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Answer Body'
    end

    scenario 'creates answer with errors', js: true do
      click_on 'Answer the Question'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'creates answer with attached files', js: true do
      fill_in 'answer_body', with: 'Answer Body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb" ]

      click_on 'Answer the Question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to answer a question', js: true do
    visit question_path(question)

    expect(page).to have_no_button 'Answer the Question'
  end
end
