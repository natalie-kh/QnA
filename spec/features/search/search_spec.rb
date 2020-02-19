require 'rails_helper'

feature 'User can search', "
  In order to find needed resource by word
  As a User
  I'd like to be able to search for resources
" do
  given!(:user) { create(:user, email: 'user@email.com') }
  given!(:test_user) { create(:user, email: 'test_sphinx@email.com') }
  given!(:question) { create(:question, user: user) }
  given!(:test_question) { create(:question, body: 'test_sphinx question', user: user) }
  given!(:comment) { create(:comment, body: 'simple comment', commentable: question, user: user) }
  given!(:test_comment) { create(:comment, body: 'test_sphinx comment', commentable: question, user: user) }
  given!(:answer) { create(:answer, body: 'simple answer', question: question, user: user) }
  given!(:test_answer) { create(:answer, body: 'test_sphinx answer', question: question, user: user) }

  context 'Search' do
    before do
      visit questions_path
    end

    scenario 'User searches by answers', sphinx: true do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'test_sphinx'
        select 'Answers', from: 'resource'
        click_on 'Search'
      end

      expect(page).to have_content 'Searching results:'
      expect(page).to have_css('.answer', text: test_answer.body.truncate(100))
      expect(page).to have_no_content test_question.body.truncate(100)
      expect(page).to have_no_content test_comment.body.truncate(100)
      expect(page).to have_no_content test_user.email
      expect(page).to have_no_css('p', class: /question|user|comment/)
    end

    scenario 'User searches by questions', sphinx: true do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'test_sphinx'
        select 'Questions', from: 'resource'
        click_on 'Search'
      end

      expect(page).to have_content 'Searching results:'
      expect(page).to have_css('.question', count: 1)
      expect(page).to have_css('.question', text: test_question.body.truncate(100))
      expect(page).to have_no_content test_answer.body.truncate(100)
      expect(page).to have_no_content test_comment.body.truncate(100)
      expect(page).to have_no_content test_user.email
      expect(page).to have_no_css('p', class: /answer|user|comment/)
    end

    scenario 'User searches by comments', sphinx: true do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'test_sphinx'
        select 'Comments', from: 'resource'
        click_on 'Search'
      end

      expect(page).to have_content 'Searching results:'
      expect(page).to have_css('.comment', count: 1)
      expect(page).to have_css('.comment', text: test_comment.body.truncate(100))
      expect(page).to have_no_content test_answer.body.truncate(100)
      expect(page).to have_no_content test_user.email
      expect(page).to have_no_content test_question.body.truncate(100)
      expect(page).to have_no_css('.results p', class: /answer|user|question/)
    end

    scenario 'User searches by users', sphinx: true do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'test_sphinx'
        select 'Users', from: 'resource'
        click_on 'Search'
      end

      expect(page).to have_content 'Searching results:'
      expect(page).to have_css('.user', count: 1)
      expect(page).to have_css('.user', text: test_user.email)
      expect(page).to have_no_content test_answer.body.truncate(100)
      expect(page).to have_no_content test_comment.body.truncate(100)
      expect(page).to have_no_content test_question.body.truncate(100)
      expect(page).to have_no_css('.results p', class: /answer|comment|question/)
    end

    scenario 'User searches by Everywhere', sphinx: true do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'test_sphinx'
        select 'Everywhere', from: 'resource'
        click_on 'Search'
      end

      expect(page).to have_content 'Searching results:'
      expect(page).to have_css('.comment', count: 1)
      expect(page).to have_css('.comment', text: test_comment.body.truncate(100))
      expect(page).to have_content test_answer.body.truncate(100)
      expect(page).to have_content test_user.email
      expect(page).to have_content test_question.body.truncate(100)
    end

    scenario 'User searches by Everywhere with empty result', sphinx: true do
      ThinkingSphinx::Test.run do
        fill_in 'query', with: 'test_sphinxtest_sphinx'
        select 'Everywhere', from: 'resource'
        click_on 'Search'
      end

      expect(page).to have_content 'No results found'
      expect(page).to have_no_css('.results p', class: /user|answer|comment|question/)
    end
  end
end
