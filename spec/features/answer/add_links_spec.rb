require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
" do
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:gist_url) { 'https://gist.github.com/natalya-bogdanova/ffc5802c87fe1efe0d04ff5d838d2bd6' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(author)

    visit question_path(question)

    fill_in 'answer_body', with: 'Answer Body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer the Question'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
