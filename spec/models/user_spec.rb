require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:nullify) }
  it { should have_many(:answers).dependent(:nullify) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer,question: question, user: author) }

  describe "user's author method" do
    it 'returns true for his question' do
      expect(author.author?(question)).to be true
    end
    it 'returns true for his answer' do
      expect(author.author?(answer)).to be true
    end
    it "returns false for another user's question" do
      expect(user.author?(question)).to be false
    end
    it "returns false for another user's answer" do
      expect(user.author?(answer)).to be false
    end
  end
end
