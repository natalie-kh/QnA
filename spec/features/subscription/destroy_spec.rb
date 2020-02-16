require 'rails_helper'

feature 'Authenticated User can unsubscribe from Question', "
  In order to unsubscribe from question updates
  As an subscribed user
  I'd like to be able to delete my subscription
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    scenario 'deletes his subscription', js: true do
      sign_in(author)
      visit question_path(question)

      click_on 'Unsubscribe'

      expect(page).to have_content 'Question subscription successfully deleted.'
      expect(page).to have_link 'Subscribe'
      expect(page).to have_no_link 'Unsubscribe'
    end

    scenario 'tries to delete subscription for another question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_no_link 'Unsubscribe'
      expect(page).to have_link 'Subscribe'
    end
  end

  scenario 'Unauthenticated user tries to delete an subscription' do
    visit question_path(question)

    expect(page).to have_no_link 'Unsubscribe'
  end
end
