require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  let(:author) { create(:user) }
  let(:answer_author1) { create(:user) }
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

  context '#accept!' do
    let!(:award) { create(:award, question: question) }
    let!(:answer1) { create(:answer, question: question, user: answer_author1) }

    before { answer.accept! }

    it 'marks answer as accepted' do
      expect(answer).to be_accepted
    end

    it 'marks another answers as not accepted' do
      accepted_answer.reload

      expect(accepted_answer).not_to be_accepted
    end

    it 'rewards answer author' do
      expect(author.awards.to_a).to include award

      answer1.accept!

      author.reload
      answer_author1.reload

      expect(author.awards.to_a).not_to include award
      expect(answer_author1.awards.to_a).to include award
    end
  end

  context '.default_scope' do
    let!(:answers) { create_list(:answer, 2, question: question, user: author) }
    before { answers.second.accept! }

    it 'should sort array by accepted and created_at date' do
      expect(question.answers.to_a).to be_eql [answers.second, accepted_answer, answer, answers.first]
    end
  end
end
