require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question, user: users.first) }
  let(:answer) { create(:answer, question: question, user: users.last) }
  let!(:subscription) { create(:subscription, question: question, user: users.second) }

  it 'calls NewAnswerMailer#send_digest' do
    expect(NewAnswerMailer).to receive(:new_answer).with(users.first, answer).and_call_original
    expect(NewAnswerMailer).to receive(:new_answer).with(users.second, answer).and_call_original
    expect(NewAnswerMailer).to_not receive(:new_answer).with(users.last, answer)

    NewAnswerJob.perform_now(answer)
  end
end
