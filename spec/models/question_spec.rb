require 'rails_helper'

RSpec.describe Question, type: :model do
  include_examples 'link association'
  include_examples 'comment association'

  it_behaves_like 'votable' do
    let!(:votable) { create(:question, user: author) }
  end

  it { should belong_to(:user) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:award).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#create_subscription' do
    let(:question) { build(:question) }

    it 'triggers #create_subscription! on save' do
      expect(question).to receive(:create_subscription!)
      question.save
    end

    it 'creates new subscription' do
      expect { question.save }.to change(Subscription, :count).by(1)
    end
  end

  context '.default_scope' do
    let(:user) { create(:user) }
    let!(:questions) { create_list(:question, 2, user: user) }

    it 'should sort array by created_at date' do
      expect(user.questions.to_a).to be_eql [questions.second, questions.first]
    end
  end
end
