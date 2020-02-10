require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted' do
    let(:question) { create(:question, user: author) }
    let!(:voted) { create(:answer, question: question, user: author) }
  end

  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new answer in db' do
        expect do
          post :create,
               params: { answer: { body: 'Body',
                                   links_attributes: {
                                     '0' => { name: 'Link',
                                              url: 'https://google.com/' }
                                   } }, question_id: question, format: :js }
        end.to change(Answer, :count).by(1)

        expect(Answer.last.links).not_to be_empty
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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'for not answer author' do
      before { login(user) }

      it "doesn't delete the answer" do
        expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
      end

      it 'returns 403: Forbidden' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response.status).to eq 403
      end
    end

    context 'for unauthorized user' do
      it "doesn't delete the answer" do
        expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
      end

      it 'returns 401: Unauthorized' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response.status).to eq 401
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: author) }
    let!(:link) { create(:link, linkable: answer) }

    context 'with valid attributes' do
      before { login(author) }

      it 'changes answer attributes' do
        patch :update,
              params: { id: answer, answer: { body: 'New Body',
                                              links_attributes: {
                                                '0' => { name: 'Edited Link Name',
                                                         url: 'https://google.com/' }
                                              } }, format: :js }
        answer.reload

        expect(answer.body).to eq 'New Body'
        expect(answer.links.last.name).to eq 'Edited Link Name'
      end

      it 'deletes answer link' do
        expect(answer.links).not_to be_empty

        patch :update,
              params: { id: answer, answer: { links_attributes:
                                                  { '0': { name: link.name,
                                                           url: link.url,
                                                           _destroy: 1, id: link.id } } },
                        format: :js }
        answer.reload

        expect(answer.links).to be_empty
      end

      it 'renders update view' do
        patch :update,
              params: { id: answer, answer: { body: 'New Body' }, format: :js }

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { login(author) }

      it 'does not change answer attributes' do
        patch :update,
              params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }

        answer.reload

        expect(answer.body).to eq 'Answer body'
      end

      it 'renders update view' do
        patch :update,
              params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }

        expect(response).to render_template :update
      end
    end

    context 'for unauthorized user' do
      it 'does not update answer' do
        patch :update,
              params: { id: answer, answer: { body: 'New Body' }, format: :js }
        answer.reload

        expect(answer.body).to eq 'Answer body'
      end

      it 'returns 401: Unauthorized' do
        patch :update,
              params: { id: answer, answer: { body: 'New Body' }, format: :js }

        expect(response.status).to eq 401
      end
    end

    context 'for not answer author' do
      before { login(user) }

      it 'does not update answer' do
        patch :update,
              params: { id: answer, answer: { body: 'New Body' }, format: :js }
        answer.reload

        expect(answer.body).to eq 'Answer body'
      end

      it 'returns 403: Forbidden' do
        patch :update,
              params: { id: answer, answer: { body: 'New Body' }, format: :js }

        expect(response.status).to eq 403
      end
    end
  end

  describe 'PATCH #accept' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'for question author' do
      before { login(author) }

      it 'accepts answer' do
        patch :accept,
              params: { id: answer, format: :js }
        answer.reload

        expect(answer).to be_accepted
      end

      it 'renders accept view' do
        patch :accept,
              params: { id: answer, format: :js }

        expect(response).to render_template :accept
      end
    end

    context 'for not question author' do
      before { login(user) }

      it 'does not accept answer' do
        patch :accept,
              params: { id: answer, format: :js }
        answer.reload

        expect(answer).not_to be_accepted
      end

      it 'returns 403: Forbidden' do
        patch :accept,
              params: { id: answer, format: :js }

        expect(response.status).to eq 403
      end
    end

    context 'for unauthorized user' do
      it 'does not accept answer' do
        patch :accept,
              params: { id: answer, format: :js }
        answer.reload

        expect(answer).not_to be_accepted
      end

      it 'returns 401: Unauthorized' do
        patch :accept,
              params: { id: answer, format: :js }

        expect(response.status).to eq 401
      end
    end
  end
end
