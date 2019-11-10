require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should validate_presence_of :body }

  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let!(:accepted_answer) { create(:answer, question: question, user: author, accepted: true) }
  let(:accepted_answer2) { create(:answer, question: question, user: author, accepted: true) }
  let!(:answer) { create(:answer, question: question, user: author, accepted: false) }

  context 'validation of uniqueness of accepted answer' do
    it 'should raise error for second accepted answer'  do
      expect { accepted_answer2 }.to raise_error
    end

    it ' not should raise error for  non-accepted answer' do
      expect { answer }.not_to raise_error
    end
  end

  context 'method accept!' do

    before { answer.accept! }

    it 'marks answer as accepted' do
      expect(answer).to be_accepted
    end

    it 'marks another answers as not accepted' do
      accepted_answer.reload

      expect(accepted_answer).not_to be_accepted
    end
  end
end
