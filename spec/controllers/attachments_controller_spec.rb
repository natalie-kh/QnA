require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:attachment) { question.files.attach(create_file_blob) }

  describe 'DELETE #destroy' do
    context 'Author' do
      before { login(author) }

      it 'deletes attached file form a question' do
        expect do
          delete :destroy,
                 params: { id: question.files.first,
                           format: :js }
        end.to change(question.files, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: question.files.first, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'Not Author' do
      before { login(user) }

      it 'deletes attached file form own question' do
        expect do
          delete :destroy,
                 params: { id: question.files.first,
                           format: :js }
        end.to_not change(question.files, :count)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: question.files.first, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'Not Authorized user' do
      it 'tries to delete attached file form a question' do
        expect do
          delete :destroy,
                 params: { id: question.files.first,
                           format: :js }
        end.to_not change(question.files, :count)
      end

      it 'returns 401: Unauthorized' do
        delete :destroy,
               params: { id: question.files.first,
                         format: :js }

        expect(response.status).to eq 401
      end
    end
  end
end
