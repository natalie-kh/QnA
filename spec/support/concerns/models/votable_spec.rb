require 'rails_helper'

shared_examples_for 'votable' do
  let!(:author) { create(:user) }
  let!(:user) { create(:user) }
  let!(:second_user) { create(:user) }
  let!(:third_user) { create(:user) }

  describe 'associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe '#vote!' do
    it 'increases rating by 1 with value = 1 ' do
      expect(votable.rating).to eq 0

      votable.vote!(user, vote_value: 1)
      expect(votable.rating).to eq 1
    end

    it 'increases rating by 1 one time' do
      expect(votable.rating).to eq 0

      votable.vote!(user, vote_value: 1)
      expect(votable.rating).to eq 1

      votable.vote!(user, vote_value: 1)
      expect(votable.rating).to eq 1
    end

    it 'reduces rating by 1 with value = -1' do
      expect(votable.rating).to eq 0

      votable.vote!(user, vote_value: -1)
      expect(votable.rating).to eq -1
    end

    it 'reduces rating by 1 one time' do
      expect(votable.rating).to eq 0

      votable.vote!(user, vote_value: -1)
      expect(votable.rating).to eq -1

      votable.vote!(user, vote_value: -1)
      expect(votable.rating).to eq -1
    end
  end

  describe '#rating' do
    it 'returns 2 for 2 for-votes' do
      expect(votable.rating).to eq 0

      votable.vote!(user, vote_value: 1)
      votable.vote!(second_user, vote_value: 1)

      expect(votable.rating).to eq 2
    end

    it 'returns -2 for 2 against-votes' do
      expect(votable.rating).to eq 0

      votable.vote!(user, vote_value: -1)
      votable.vote!(second_user, vote_value: -1)

      expect(votable.rating).to eq -2
    end

    it 'returns 1 for 2 for-votes and 1 against-votes' do
      expect(votable.rating).to eq 0

      votable.vote!(user, vote_value: 1)
      votable.vote!(second_user, vote_value: 1)
      votable.vote!(third_user, vote_value: -1)

      expect(votable.rating).to eq 1
    end
  end
end


