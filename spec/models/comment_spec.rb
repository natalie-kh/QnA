require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :user }
  it { should belong_to :commentable }

  it { should validate_presence_of :body }

  context '.default_scope' do
    let(:question) { create(:question) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }

    it 'should sort array by created_at date' do
      expect(question.comments.to_a).to be_eql [comments.first, comments.second]
    end
  end
end
