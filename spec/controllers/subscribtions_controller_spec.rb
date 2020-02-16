require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }

  describe 'POST #create' do
    context 'for authorized user' do
      before { login(user) }

      it 'saves a new subscription in db' do
        expect do
          post :create, params: { question_id: question.id }, format: :js
        end.to change(Subscription, :count).by(1)
      end

      it 'assigns the subscription to correct question' do
        post :create, params: { question_id: question.id }, format: :js
        expect(assigns(:subscription).question).to eq question
      end

      it 'assigns the subscription to current_user' do
        post :create, params: { question_id: question.id }, format: :js

        expect(assigns(:subscription).user).to eq user
      end

      it 'renders create js view' do
        post :create, params: { question_id: question.id }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'for unauthorized user' do
      it 'does not create new subscription' do
        expect do
          post :create, params: { question_id: question.id }, format: :js
        end.to_not change(Subscription, :count)
      end

      it 'returns 401: Unauthorized' do
        post :create, params: { question_id: question.id }, format: :js

        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'for subscribed user' do
      before { login(author) }

      it 'deletes the subscription' do
        expect { delete :destroy, params: { id: question.subscriptions.first }, format: :js }.to change(Subscription, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: question.subscriptions.first, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'for not subscribed user' do
      before { login(user) }

      it "doesn't delete the subscription" do
        expect { delete :destroy, params: { id: question.subscriptions.first }, format: :js }.not_to change(Subscription, :count)
      end

      it 'returns 403: Forbidden' do
        delete :destroy, params: { id: question.subscriptions.first }, format: :js
        expect(response.status).to eq 403
      end
    end

    context 'for unauthorized user' do
      it "doesn't delete the subscription" do
        expect { delete :destroy, params: { id: question.subscriptions.first }, format: :js }.not_to change(Subscription, :count)
      end

      it 'returns 401: Unauthorized' do
        delete :destroy, params: { id: question.subscriptions.first }, format: :js
        expect(response.status).to eq 401
      end
    end
  end
end
