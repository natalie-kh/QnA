require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new comment in db' do
        expect do
          post :create, params: { comment: attributes_for(:comment), question_id: question.id }, format: :js
        end.to change(Comment, :count).by(1)
      end

      it 'assigns the comment to correct question' do
        post :create, params: { comment: attributes_for(:comment), question_id: question.id }, format: :js
        expect(assigns(:comment).commentable).to eq question
      end

      it 'assigns the comment to current_user' do
        post :create, params: { comment: attributes_for(:comment), question_id: question.id }, format: :js

        expect(assigns(:comment).user).to eq user
      end

      it 'renders create view' do
        post :create, params: { comment: attributes_for(:comment), question_id: question.id }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not create new comment' do
        expect do
          post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question.id }, format: :js
        end.to_not change(Comment, :count)
      end

      it 'renders create js view' do
        post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question.id }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'for unauthorized user' do
      it 'does not create new comment' do
        expect do
          post :create, params: { comment: attributes_for(:comment), question_id: question.id }, format: :js
        end.to_not change(Comment, :count)
      end

      it 'returns 401: Unauthorized' do
        post :create, params: { comment: attributes_for(:comment), question_id: question.id }, format: :js

        expect(response.status).to eq 401
      end
    end
  end
end
