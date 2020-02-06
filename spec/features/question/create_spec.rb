require 'rails_helper'

feature 'User can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask Question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Question Title'
      fill_in 'Body', with: 'Question Body'
      click_on 'Ask Question'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Question Title'
      expect(page).to have_content 'Question Body'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask Question'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: 'Question Title'
      fill_in 'Body', with: 'Question Body'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask Question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user can not ask a question' do
    visit questions_path

    expect(page).to have_no_link 'Ask Question'
  end

  context 'multiple sessions', :cable do
    background do
      Capybara.using_session('author') do
        sign_in(user)
        visit questions_path
        expect(page).to have_no_content 'Test question'
      end

      Capybara.using_session('guest') do
        visit questions_path
        expect(page).to have_no_content 'Test question'
      end
    end

    scenario 'all users see new question in real-time', js: true do
      Capybara.using_session('author') do
        click_on 'Ask Question'

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test text'
        click_on 'Ask Question'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'
      end
    end

    scenario 'Question with errors does not appear on another user page', js: true do
      Capybara.using_session('author') do
        click_on 'Ask Question'

        fill_in 'Body', with: 'Test question'
        click_on 'Ask Question'

        expect(page).to have_content "Title can't be blank"
      end

      Capybara.using_session('guest') do
        expect(page).to have_no_content 'Test question'
      end
    end
  end
end
