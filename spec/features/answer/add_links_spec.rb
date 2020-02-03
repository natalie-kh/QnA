require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
" do
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:github_url) { 'https://github.com/natalya-bogdanova' }
  given(:google_url) { 'https://www.google.com' }

  describe 'Authenticated user' do
    background do
      sign_in(author)
      visit question_path(question)

      click_on 'Add New Answer'
      click_on 'add link'
      fill_in 'answer_body', with: 'Answer Body'
      fill_in 'Link name', with: 'My github'
    end

    scenario 'adds link when give an answer', js: true do
      fill_in 'Url', with: github_url

      click_on 'Answer the Question'

      within '.answers' do
        expect(page).to have_link 'My github', href: github_url
      end
    end

    scenario 'adds links when give an answer', js: true do
      fill_in 'Url', with: github_url

      click_on 'add link'

      within all('.nested-fields')[1] do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: google_url
      end

      click_on 'Answer the Question'

      within '.answers' do
        expect(page).to have_link 'My github', href: github_url
        expect(page).to have_link 'Google', href: google_url
      end
    end

    scenario 'adds link with error', js: true do
      click_on 'Answer the Question'

      expect(page).to have_content "Links url can't be blank"
    end

    scenario 'removes link form', js: true do
      expect(page).to have_css('.nested-fields')

      click_on 'remove link'

      expect(page).to have_no_css('.nested-fields')
    end

    scenario 'adds link with wrong url', js: true do
      fill_in 'Url', with: 'google_url'
      click_on 'Answer the Question'

      expect(page).to have_content 'Links url is invalid'
    end
  end
end
