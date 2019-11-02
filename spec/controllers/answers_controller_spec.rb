require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new views' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in db' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer),
                         question_id: question }
        end.to change(Answer, :count).by(1)
      end

      it 'redirects to show question view' do
        post :create, params: { answer: attributes_for(:answer),
                                question_id: question.id }

        expect(response).to redirect_to assigns(:question)
      end

      it 'assigns the answer to correct question' do
        post :create, params: { answer: attributes_for(:answer),
                                question_id: question.id }
        expect(assigns(:answer).question).to eq question
      end
    end

    context 'with invalid attributes' do
      it 'does not create new answer' do
        expect do
          post :create,
               params: { answer: attributes_for(:answer, :invalid),
                         question_id: question }
        end.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create,
             params: { answer: attributes_for(:answer, :invalid),
                       question_id: question }

        expect(response).to render_template :new
      end
    end
  end
end
