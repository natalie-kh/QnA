class DailyDigestService
  def send_digest
    return unless Question.exists?(created_at: Date.yesterday.all_day)

    User.find_each do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
