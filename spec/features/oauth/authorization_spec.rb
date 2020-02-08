require 'rails_helper'

feature 'User can authorize with Oauth', "
  In order to register/login to platform
  As an user
  I'd like to be able to sign_in/sign_up with my another site account
" do

  describe 'Github' do
    background do
      visit new_user_session_path
      expect(page).to have_content 'Sign in with GitHub'
    end

    context 'new user' do
      it 'can sign_in with GitHub account' do
        mock_auth_hash :github, email: 'test@mail.ru'
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account'
      end
    end

    context 'already existed user' do
      let!(:user) { create(:user) }

      it 'can sign_in ith GitHub account' do
        mock_auth_hash :github, email: user.email
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account'
      end
    end

    context 'user with authorization' do
      let!(:user) { create(:user) }
      let!(:authorization) { create(:authorization, user: user) }

      it 'can sign_in with GitHub account' do
        mock_auth_hash :github, email: user.email
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account'
      end
    end
  end
end
