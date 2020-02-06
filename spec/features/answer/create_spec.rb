require 'rails_helper'

feature 'User can create answers for a question', "
  In order to set answer for community
  As an authenticated user
  I'd like to be able to write answers to questions
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question2) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
      click_on 'Add New Answer'
    end

    scenario 'answers the question', js: true do
      fill_in 'answer_body', with: 'Answer Body'
      click_on 'Answer the Question'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Answer Body'
    end

    scenario 'creates answer with errors', js: true do
      click_on 'Answer the Question'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'creates answer with attached files', js: true do
      fill_in 'answer_body', with: 'Answer Body'

      within('.new_answer') do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"], make_visible: true
      end

      click_on 'Answer the Question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to answer a question', js: true do
    visit question_path(question)

    expect(page).to have_no_button 'Answer the Question'
    expect(page).to have_no_link 'Add New Answer'
  end

  context 'multiple sessions', :cable do
    background do
      Capybara.using_session('author') do
        sign_in(user)
        visit question_path(question)
        expect(page).to have_no_content 'Test Answer'
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        expect(page).to have_no_content 'Test Answer'
      end
    end

    scenario 'all users see new answers in real-time', js: true do
      Capybara.using_session('author') do
        click_on 'Add New Answer'

        fill_in 'answer_body', with: 'Test Answer'
        click_on 'Answer the Question'

        expect(page).to have_content 'Your answer successfully created.'
        expect(page).to have_content 'Test Answer', count: 1
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test Answer', count: 1
      end
    end

    scenario 'Answers with errors does not appear on another user page', js: true do
      Capybara.using_session('author') do
        click_on 'Add New Answer'

        click_on 'Answer the Question'

        expect(page).to have_content "Body can't be blank"
      end

      Capybara.using_session('guest') do
        expect(page).to have_no_content "Body can't be blank"
      end
    end

    scenario 'New answer appears on necessary question page only', js: true do
      Capybara.using_session('guest') do
        visit question_path(question2)
        expect(page).to have_no_content 'Test Answer'
      end

      Capybara.using_session('author') do
        click_on 'Add New Answer'

        fill_in 'answer_body', with: 'Test Answer'
        click_on 'Answer the Question'

        expect(page).to have_content 'Your answer successfully created.'
        expect(page).to have_content 'Test Answer', count: 1
      end

      Capybara.using_session('guest') do
        expect(page).to have_no_content 'Test Answer'
      end
    end
  end
end
