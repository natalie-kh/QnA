require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given(:google_url) { 'https://www.google.com' }

  scenario 'Unauthenticated user can not to edit answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in author
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Body', with: 'Edited answer body'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in author
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's answer", js: true do
      sign_in user
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'attaches files with answer editing', js: true do
      sign_in author
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'adds link with answer editing', js: true do
      sign_in author
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        click_on 'add link'

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: google_url
        click_on 'Save'

        expect(page).to have_link 'My gist', href: google_url
      end
    end
  end

  describe 'Answer author' do
    given!(:link) { create(:link, linkable: answer) }

    background do
      answer.files.attach(create_file_blob)
      sign_in author
      visit question_path(question)
    end

    scenario 'deletes attached file', js: true do
      within '.answers' do
        expect(page).to have_link 'image.jpg'
        expect(page).to have_link 'x'
        click_on 'x'

        expect(page).to_not have_link 'image.jpg'
      end
    end

    scenario 'deletes attached link', js: true do
      within '.answers' do
        click_on 'Edit'
        expect(page).to have_link link.name
        expect(page).to have_link 'remove link'
        click_on 'remove link'
        click_on 'Save'
      end

      visit question_path(question)
      expect(page).to_not have_link 'link.name'
    end
  end

  describe 'Not Answer author' do
    background do
      answer.files.attach(create_file_blob)
      sign_in user
      visit question_path(question)
    end

    scenario 'tries to delete attached file', js: true do
      within '.answers' do
        expect(page).to have_link 'image.jpg'
        expect(page).to have_no_link 'x'
      end
    end
  end
end
