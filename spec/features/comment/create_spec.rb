require 'rails_helper'

feature 'User can create answers for a question', "
  In order to clarify answers or questions
  As an authenticated user
  I'd like to be able to write comments
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question2) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
      expect(page).to have_no_css('.question .comments', text: 'First Comment')
    end

    scenario 'create comment for the question', js: true do
      within('.question') do
        fill_in 'comment_body', with: 'First Comment'
        click_on 'Post the Comment'

        expect(page).to have_css('.question .comments', text: 'First Comment')
      end
      expect(page).to have_content 'Your comment successfully created.'
    end

    scenario 'creates comment with errors', js: true do
      within('.question') do
        click_on 'Post the Comment'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to comment a question', js: true do
    visit question_path(question)

    expect(page).to have_no_button 'Post the Comment'
  end

  context 'multiple sessions', :cable do
    describe 'questions comment' do
      background do
        Capybara.using_session('author') do
          sign_in(user)
          visit question_path(question)
          expect(page).to have_no_content 'Test Comment'
        end

        Capybara.using_session('guest') do
          visit question_path(question)
          expect(page).to have_no_content 'Test Comment'
        end
      end

      scenario 'all users see new comments for question in real-time', js: true do
        Capybara.using_session('author') do
          within('.question') do
            fill_in 'comment_body', with: 'Test Comment'
            click_on 'Post the Comment'

            expect(page).to have_content 'Test Comment', count: 1
          end
          expect(page).to have_content 'Your comment successfully created.'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Test Comment', count: 1
        end
      end

      scenario 'Comments with errors does not appear on another user page', js: true do
        Capybara.using_session('author') do
          within('.question') do
            click_on 'Post the Comment'
          end

          expect(page).to have_content "Body can't be blank"
        end

        Capybara.using_session('guest') do
          expect(page).to have_no_content "Body can't be blank"
        end
      end

      scenario 'New comments appears on necessary question page only', js: true do
        Capybara.using_session('guest') do
          visit question_path(question2)
          expect(page).to have_no_content 'Test Comment'
        end

        Capybara.using_session('author') do
          within('.question') do
            fill_in 'comment_body', with: 'Test Comment'
            click_on 'Post the Comment'

            expect(page).to have_content 'Test Comment', count: 1
          end
          expect(page).to have_content 'Your comment successfully created.'
        end

        Capybara.using_session('guest') do
          expect(page).to have_no_content 'Test Comment'
        end
      end
    end

    describe 'answers comment' do
      background do
        Capybara.using_session('author') do
          sign_in(user)
          visit question_path(question)
          expect(page).to have_no_content 'Test Comment'
        end

        Capybara.using_session('guest') do
          visit question_path(question)
          expect(page).to have_no_content 'Test Comment'
        end
      end

      scenario 'all users see new comments for answer in real-time', js: true do
        Capybara.using_session('author') do
          within(".answer.answer-#{answer.id}") do
            fill_in 'comment_body', with: 'Test Comment'
            click_on 'Post the Comment'

            expect(page).to have_content 'Test Comment', count: 1
          end
          expect(page).to have_content 'Your comment successfully created.'
        end

        Capybara.using_session('guest') do
          within(".answer.answer-#{answer.id}") do
            expect(page).to have_content 'Test Comment', count: 1
          end
        end
      end

      scenario 'Comments with errors does not appear on another user page', js: true do
        Capybara.using_session('author') do
          within(".answer.answer-#{answer.id}") do
            click_on 'Post the Comment'
          end

          expect(page).to have_content "Body can't be blank"
        end

        Capybara.using_session('guest') do
          expect(page).to have_no_content "Body can't be blank"
        end
      end

      scenario 'New comments appears for necessary answer only', js: true do
        Capybara.using_session('author') do
          within(".answer.answer-#{answer.id}") do
            fill_in 'comment_body', with: 'Test Comment'
            click_on 'Post the Comment'

            expect(page).to have_content 'Test Comment', count: 1
          end
          expect(page).to have_content 'Test Comment', count: 1
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Test Comment', count: 1
        end
      end
    end
  end
end
