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

    it 'renders new views' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new question with link in db' do
        expect do
          post :create, params: {
            question: {
              title: 'Title', body: 'Body',
              links_attributes: { '0' => { name: 'Link',
                                           url: 'https://google.com/' } }
            }
          }
        end.to change(Question, :count).by(1)

        expect(Question.last.links).not_to be_empty
      end

      it 'saves a new question with award in db' do
        expect do
          post :create, params: {
            question: {
              title: 'Title', body: 'Body',
              award_attributes: { name: 'New Award',
                                  image: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/image.jpg'), 'image/jpeg') }
            }
          }
        end.to change(Question, :count).by(1)

        expect(Question.last.award.name).to eq 'New Award'
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
      let!(:link) { create(:link, linkable: question) }

      before { login(author) }

      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question,
                                 question: { title: 'new title', body: 'new body',
                                             links_attributes: {
                                               '0' => { name: 'Edited Link Name',
                                                        url: 'https://google.com/' }
                                             } }, format: :js }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
        expect(question.links.last.name).to eq 'Edited Link Name'
      end

      it 'renders update view' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end

      it 'deletes question link' do
        expect(question.links).not_to be_empty

        patch :update,
              params: { id: question, question: { links_attributes:
                                                  { '0': { name: link.name,
                                                           url: link.url,
                                                           _destroy: 1, id: link.id } } },
                        format: :js }
        question.reload

        expect(question.links).to be_empty
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
