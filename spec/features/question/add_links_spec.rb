require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:author) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/natalya-bogdanova/ffc5802c87fe1efe0d04ff5d838d2bd6' }

  scenario 'User adds link when asks question' do
    sign_in(author)

    visit new_question_path

    fill_in 'Title', with: 'Question Title'
    fill_in 'Body', with: 'Question Body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask Question'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
