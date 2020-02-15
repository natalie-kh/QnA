class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where('DATE(created_at) = ?', Date.yesterday)
    return if @questions.empty?

    mail to: user.email, subject: 'Daily Updates'
  end
end
