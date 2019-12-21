require 'rails_helper'

feature 'User can vote for answer', "
  As an authenticated user and not answer author
  I'd like to be able to vote for answer
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Not answer author', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'votes for answer' do
      within('.answers') do
        expect(page).to have_content 'Rating: 0'
        click_on '▲'

        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'votes against answer' do
      within('.answers') do
        click_on '▼'

        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario 'votes only 1 time for answer' do
      within('.answers') do
        expect(page).to have_content 'Rating: 0'

        click_on '▲'
        expect(page).to have_content 'Rating: 1'

        click_on '▲'
        expect(page).to have_content 'Rating: 1'
      end
    end
  end

  describe 'Answer author', js: true do
    background do
      sign_in author
      visit question_path(question)
    end

    scenario 'cannot vote' do

      within('.answers') do
        expect(page).to have_no_button('▲')
        expect(page).to have_no_button('▼')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'cannot vote' do
      visit question_path(question)

      within('.answers') do
        expect(page).to have_no_button('up')
        expect(page).to have_no_button('down')
      end
    end
  end
end

