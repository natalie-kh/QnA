require 'rails_helper'

RSpec.describe MyAwardsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:question2) { create(:question, user: author) }
  let(:award) { create(:award, question: question) }
  let(:award2) { create(:award, question: question2) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:answer2) { create(:answer, question: question2, user: user) }
  let!(:accept_answer) { answer.accept! }
  let!(:accept_answer2) { answer2.accept! }


  describe 'GET #index' do
    context 'Authenticated user' do
      before do
        login(user)
        get :index
      end

      it 'populates an array of all awards' do
        expect(assigns(:my_awards)).to match_array(user.awards)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'Unauthenticated user' do
      before { get :index }

      it 'redirects to sign_in form' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
