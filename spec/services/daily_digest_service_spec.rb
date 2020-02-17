require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 2) }

  context 'for empty question list' do
    it 'does not send daily digest to all users' do
      users.each { |user| expect(DailyDigestMailer).to_not receive(:digest).with(user) }
      subject.send_digest
    end
  end

  context 'for not empty question list' do
    let!(:question) { create(:question, user: users.first) }

    before { question.update!(created_at: Date.yesterday) }

    it 'sends daily digest to all users' do
      users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original }
      subject.send_digest
    end
  end
end
