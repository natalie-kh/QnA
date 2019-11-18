require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, user: author) }
  let(:user) { create(:user) }
  let(:author) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: author) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show views' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new link for @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new views' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new question in db' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end

      it 'assigns the question to current_user' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).user).to eq user
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end

    context 'for unauthorized user' do

      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 'redirects to sign_in form' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do

    context 'with valid attributes' do
      before { login(author) }

      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { login(author) }
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js } }

      it 'does not save changes' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'for unauthorized user' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js } }

      it 'does not update question' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 'returns 401: Unauthorized' do
        expect(response.status).to eq 401
      end
    end

    context 'for not question author' do
      before { login(user) }
      before { patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js } }

      it 'does not update question' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-render question' do
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: author) }

    before { question }

    context 'for question author' do
      before { login(author) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'for not question author' do
      before { login(user) }

      it "doesn't delete the question" do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 're-render question' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'for unauthorized user' do

      it "doesn't delete the question" do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'redirects to sign_in form' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
