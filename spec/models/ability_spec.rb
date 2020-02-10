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
    let(:question) { create :question, user_id: user.id }
    let(:other_question) { create :question, user_id: other.id }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, Award }

    context 'POST #create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end

    context 'PUT #update' do
      it { should be_able_to :update, create(:question, user_id: user.id) }
      it { should_not be_able_to :update, create(:question, user_id: other.id) }

      it { should be_able_to :update, create(:answer, question_id: question.id, user_id: user.id) }
      it { should_not be_able_to :update, create(:answer, question_id: question.id, user_id: other.id) }
    end

    context 'DELETE #destroy' do
      it { should be_able_to :destroy, create(:question, user_id: user.id) }
      it { should_not be_able_to :destroy, create(:question, user_id: other.id) }

      it { should be_able_to :destroy, create(:answer, question_id: question.id, user_id: user.id) }
      it { should_not be_able_to :destroy, create(:answer, question_id: question.id, user_id: other.id) }

      context 'attachments' do
        let!(:attachment) { question.files.attach(create_file_blob) }
        let!(:other_attachment) { other_question.files.attach(create_file_blob) }

        it { should be_able_to :destroy, question.files.first }
        it { should_not be_able_to :destroy, other_question.files.first }
      end
    end

    context 'PATCH #accept' do
      it { should be_able_to :accept, create(:answer, question_id: question.id, user_id: user.id) }
      it { should_not be_able_to :accept, create(:answer, question_id: other_question.id, user_id: user.id) }
    end

    context 'POST #vote' do
      it { should be_able_to :vote, create(:question, user_id: other.id) }
      it { should_not be_able_to :vote, create(:question, user_id: user.id) }

      it { should be_able_to :vote, create(:answer, question_id: question.id, user_id: other.id) }
      it { should_not be_able_to :vote, create(:answer, question_id: question.id, user_id: user.id) }
    end
  end
end
