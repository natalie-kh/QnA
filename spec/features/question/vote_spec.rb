require 'rails_helper'

feature 'User can vote for question', "
  As an authenticated user and not question author
  I'd like to be able to vote for question
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Not question author', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'votes for question' do
      within('.question') do
        expect(page).to have_css('.circle', text: '0')
        click_on '▲'

        expect(page).to have_css('.circle', text: '1')
      end
    end

    scenario 'votes against question' do
      within('.question') do
        click_on '▼'

        expect(page).to have_css('.circle', text: '-1')
      end
    end

    scenario 'votes only 1 time for question' do
      within('.question') do
        expect(page).to have_css('.circle', text: '0')

        click_on '▲'
        expect(page).to have_css('.circle', text: '1')

        click_on '▲'
        expect(page).to have_css('.circle', text: '1')
      end
    end
  end

  describe 'Question author', js: true do
    background do
      sign_in author
      visit question_path(question)
    end

    scenario 'cannot vote' do
      within('.question') do
        expect(page).to have_no_button('▲')
        expect(page).to have_no_button('▼')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'cannot vote' do
      visit question_path(question)

      within('.question') do
        expect(page).to have_no_button('▲')
        expect(page).to have_no_button('▼')
      end
    end
  end
end
