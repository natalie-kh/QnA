require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:author) { create(:user) }
  given(:github_url) { 'https://github.com/natalya-bogdanova' }
  given(:gist_url) { 'https://gist.github.com/natalya-bogdanova/59312d83a6e67827186ee969dbd18ef8' }
  given(:wrong_gist_url) { 'https://gist.github.com/natalya-bogdanova/59312d8' }
  given(:google_url) { 'https://www.google.com' }

  describe 'Authenticated user' do
    background do
      sign_in(author)

      visit new_question_path

      fill_in 'Title', with: 'Question Title'
      fill_in 'Body', with: 'Question Body'

      click_on 'add link'
      fill_in 'Link name', with: 'My github'
    end

    scenario 'adds link when asks question', js: true do
      fill_in 'Url', with: github_url
      click_on 'Ask Question'

      expect(page).to have_link 'My github', href: github_url
    end

    scenario 'adds gist when asks question', js: true do
      fill_in 'Url', with: gist_url
      click_on 'Ask Question'

      within '.question' do
        expect(page).to have_no_link 'My github'
        expect(page).to have_content "Hello\nI'm a gist"
      end
    end

    scenario 'adds wrong gist when asks question', js: true do
      fill_in 'Url', with: wrong_gist_url
      click_on 'Ask Question'

      within '.question' do
        expect(page).to have_no_link 'My github'
        expect(page).to have_content 'Loading gist'
      end
    end

    scenario 'adds links when asks question', js: true do
      fill_in 'Url', with: github_url
      click_on 'add link'

      within all('.nested-fields')[1] do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: google_url
      end

      click_on 'Ask Question'

      expect(page).to have_link 'My github', href: github_url
      expect(page).to have_link 'Google', href: google_url
    end

    scenario 'adds link with error', js: true do
      click_on 'Ask Question'

      expect(page).to have_content "Links url can't be blank"
    end

    scenario 'removes link form', js: true do
      expect(page).to have_css('.nested-fields')

      click_on 'remove link'

      expect(page).to have_no_css('.nested-fields')
    end

    scenario 'adds link with wrong url', js: true do
      fill_in 'Url', with: 'google_url'
      click_on 'Ask Question'

      expect(page).to have_content 'Links url is invalid'
    end
  end

  describe 'Question Author' do
    given!(:question) { create(:question, user: author) }

    background do
      sign_in(author)

      visit question_path(question)
    end

    scenario 'adds link when edit question', js: true do

      within '.question' do
        click_on 'Edit'
        click_on 'add link'

        fill_in 'Link name', with: 'My github'
        fill_in 'Url', with: github_url
        click_on 'Save'
      end

      expect(page).to have_link 'My github', href: github_url
    end
  end
end
