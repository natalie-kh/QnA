require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:author) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/natalya-bogdanova/ffc5802c87fe1efe0d04ff5d838d2bd6' }
  given(:google_url) { 'https://www.google.com' }

  describe 'Authenticated user' do
    background do
      sign_in(author)

      visit new_question_path

      fill_in 'Title', with: 'Question Title'
      fill_in 'Body', with: 'Question Body'

      fill_in 'Link name', with: 'My gist'
    end

    scenario 'adds link when asks question' do
      fill_in 'Url', with: gist_url
      click_on 'Ask Question'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'adds links when asks question', js: true do
      fill_in 'Url', with: gist_url
      click_on 'add link'

      within all('.nested-fields')[1] do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: google_url
      end

      click_on 'Ask Question'

      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'Google', href: google_url
    end

    scenario 'adds link with error' do
      click_on 'Ask Question'

      expect(page).to have_content "Links url can't be blank"
    end

    scenario 'removes link form', js: true do
      expect(page).to have_css('.nested-fields')

      click_on 'remove link'

      expect(page).to have_no_css('.nested-fields')
    end

    scenario 'adds link with wrong url' do
      fill_in 'Url', with: 'google_url'
      click_on 'Ask Question'

      expect(page).to have_content 'Links url is invalid'
    end
  end
end
