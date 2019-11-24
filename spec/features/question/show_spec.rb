require 'rails_helper'

feature 'User can show question and answers to it', "
  In order to read answers for a question
  As an authenticated or unauthenticated user
  I'd like to be able to show question and answers to it
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'Authenticated user shows question and answers', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content('Answer body', count: 3)
  end

  scenario 'Unauthenticated user shows question and answers', js: true do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content('Answer body', count: 3)
  end
end
