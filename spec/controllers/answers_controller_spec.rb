require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }

  describe 'POST #create' do

    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new answer in db' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer),
                         question_id: question, format: :js }
        end.to change(Answer, :count).by(1)
      end

      it 'redirects to show question view' do
        post :create, params: { answer: attributes_for(:answer),
                                question_id: question.id, format: :js }

        expect(response).to render_template :create
      end

      it 'assigns the answer to correct question' do
        post :create, params: { answer: attributes_for(:answer),
                                question_id: question.id, format: :js }
        expect(assigns(:answer).question).to eq question
      end

      it 'assigns the answer to current_user' do
        post :create, params: { answer: attributes_for(:answer),
                                question_id: question.id, format: :js }

        expect(assigns(:answer).user).to eq user
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not create new answer' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, :invalid),
                         question_id: question, format: :js }
        end.to_not change(Answer, :count)
      end

      it 'renders create js view' do
        post :create,
             params: { answer: attributes_for(:answer, :invalid),
                       question_id: question, format: :js }

        expect(response).to render_template :create
      end
    end

    context 'for unauthorized user' do
      it 'does not create new answer' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, :invalid),
                         question_id: question, format: :js }
        end.to_not change(Answer, :count)
      end

      it 'returns 401: Unauthorized' do
        post :create,
             params: { answer: attributes_for(:answer, :invalid),
                       question_id: question, format: :js }

        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: author) }

    context 'for answer author' do
      before { login(author) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'for not answer author' do
      before { login(user) }

      it "doesn't delete the answer" do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
      end

      it 're-render question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'for unauthorized user' do
      it "doesn't delete the answer" do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
      end

      it 'redirects to sign_in form' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: author) }

    context 'with valid attributes' do
      before { login(author) }

      it 'changes answer attributes' do
        patch :update,
              params: { id: answer, answer: { body: 'New Body'}, format: :js }
        answer.reload

        expect(answer.body).to eq 'New Body'
      end

      it 'renders update view' do
        patch :update,
              params: { id: answer, answer: { body: 'New Body'}, format: :js }

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { login(author) }

      it 'does not change answer attributes' do
        expect do
          patch :update,
                params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update,
              params: {id: answer, answer: attributes_for(:answer, :invalid), format: :js }

        expect(response).to render_template :update
      end
    end

    context 'for unauthorized user' do
      it 'does not update answer' do
        expect do
          patch :update,
                params: { id: answer, answer: { body: 'New Body'}, format: :js }
        end.to_not change(answer, :body)
      end

      it 'returns 401: Unauthorized' do
        patch :update,
              params: { id: answer, answer: { body: 'New Body'}, format: :js }

        expect(response.status).to eq 401
      end
    end
  end
end
