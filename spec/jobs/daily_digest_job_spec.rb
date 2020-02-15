require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double('DailyDigestService') }

  before { allow(DailyDigestService).to receive(:new).and_return(service) }

  it 'calls DailyDigestService#send_digest' do
    expect(service).to receive(:send_digest)
    DailyDigestJob.perform_now
  end
end
