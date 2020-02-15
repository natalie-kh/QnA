require 'rails_helper'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe '#guest_ability' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should_not be_able_to :read, Award }

    it { should_not be_able_to :manage, :all }
  end

  describe '#admin_ability' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe '#user_ability' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { build :question, user_id: user.id }
    let(:other_question) { build :question, user_id: other.id }
    let(:answer) { build(:answer, question: question, user_id: user.id) }
    let(:other_answer) { build(:answer, question: question, user_id: other.id) }
    let(:subscription) { build(:subscription, question: question, user_id: user.id) }
    let(:other_subscription) { build(:subscription, question: question, user_id: other.id) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, Award }

    context 'POST #create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
      it { should be_able_to :create, Subscription }
    end

    context 'PUT #update' do
      it { should be_able_to :update, question }
      it { should_not be_able_to :update, other_question }

      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, other_answer }
    end

    context 'DELETE #destroy' do
      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, other_question }

      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, other_answer }

      it { should be_able_to :destroy, subscription }
      it { should_not be_able_to :destroy, other_subscription }

      context 'attachments' do
        let!(:attachment) { question.files.attach(create_file_blob) }
        let!(:other_attachment) { other_question.files.attach(create_file_blob) }

        it { should be_able_to :destroy, question.files.first }
        it { should_not be_able_to :destroy, other_question.files.first }
      end
    end

    context 'PATCH #accept' do
      it { should be_able_to :accept, answer }
      it { should be_able_to :accept, other_answer }
      it { should_not be_able_to :accept, create(:answer, question: other_question, user_id: user.id) }
    end

    context 'POST #vote' do
      it { should be_able_to :vote, other_question }
      it { should_not be_able_to :vote, question }

      it { should be_able_to :vote, other_answer }
      it { should_not be_able_to :vote, answer }
    end
  end
end
