class DailyDigestPreview < ActionMailer::Preview
  def digest
    DailyDigestMailer.digest
  end
end
