require 'rails_helper'

feature 'Authenticated User can subscribe to Question', "
  In order to track the creation of new answers
  As an authenticated user
  I'd like to be able to subscribe to the question
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    scenario 'subscribes to another user question', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'Subscribe'

      expect(page).to (have_content 'Question subscription successfully created.')
      expect(page).to have_link 'Unsubscribe'
      expect(page).to have_no_link 'Subscribe'
    end

    scenario 'subscribes to own question' do
      sign_in(author)
      visit question_path(question)

      expect(page).to have_link 'Unsubscribe'
      expect(page).to have_no_link 'Subscribe'
    end
  end

  scenario 'Unauthenticated user tries to subscribe to a question' do
    visit question_path(question)

    expect(page).to have_no_link 'Subscribe'
  end
end
