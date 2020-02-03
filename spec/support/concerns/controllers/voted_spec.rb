require 'rails_helper'

shared_examples_for 'voted' do
  let!(:author) { create(:user) }
  let!(:user) { create(:user) }

  describe 'POST #vote' do
    context 'for not votable author' do
      before { login(user) }

      it 'saves a new vote in db' do
        expect do
          post :vote, params: { id: voted, voted: { value: 1 }, format: :json }
        end.to change(Vote, :count).by(1)

        expect(Vote.last.value).to eq 1
      end

      it 'render valid json' do
        post :vote, params: { id: voted, voted: { value: 1 }, format: :json }

        expected = { votable_type: voted.class.to_s,
                     votable_id: voted.id,
                     votes: voted.rating }.to_json

        expect(response) == expected
      end
    end

    context 'for votable author' do
      before { login(author) }

      it 'does not create new vote' do
        expect do
          post :vote, params: { id: voted, voted: { value: 1 }, format: :json }
        end.not_to change(Vote, :count)
      end

      it 'returns 403: Forbidden' do
        post :vote, params: { id: voted, voted: { value: 1 }, format: :json }

        expect(response.status).to eq 403
      end
    end

    context 'for unauthorized user' do
      it 'does not create new vote' do
        expect do
          post :vote, params: { id: voted, voted: { value: 1 }, format: :json }
        end.not_to change(Vote, :count)
      end

      it 'returns 401: Unauthorized' do
        post :vote, params: { id: voted, voted: { value: 1 }, format: :json }

        expect(response.status).to eq 401
      end
    end
  end
end
