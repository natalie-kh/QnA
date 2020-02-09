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
        mock_auth_hash :github
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account'
      end
    end

    context 'already existed user' do
      let!(:user) { create(:user) }

      it 'can sign_in with GitHub account' do
        mock_auth_hash :github, email: user.email
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account'
      end
    end

    context 'user with authorization' do
      let!(:user) { create(:user) }
      let!(:authorization) { create(:authorization, :github, user: user) }

      it 'can sign_in with GitHub account' do
        mock_auth_hash :github, uid: authorization.uid, email: user.email
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account'
      end
    end
  end

  describe 'Facebook' do
    background do
      visit new_user_session_path

      expect(page).to have_content 'Sign in with Facebook'
    end

    context 'new user' do
      it 'can sign_in with Facebook account' do
        mock_auth_hash :facebook
        click_on 'Sign in with Facebook'

        expect(page).to have_content 'Successfully authenticated from Facebook account'
      end
    end

    context 'already existed user' do
      let!(:user) { create(:user) }

      it 'can sign_in with Facebook account' do
        mock_auth_hash :facebook, email: user.email
        click_on 'Sign in with Facebook'

        expect(page).to have_content 'Successfully authenticated from Facebook account'
      end
    end

    context 'user with authorization' do
      let!(:user) { create(:user) }
      let!(:authorization) { create(:authorization, :facebook, user: user) }

      it 'can sign_in with Facebook account' do
        mock_auth_hash :facebook, uid: authorization.uid, email: user.email
        click_on 'Sign in with Facebook'

        expect(page).to have_content 'Successfully authenticated from Facebook account'
      end
    end
  end
end
