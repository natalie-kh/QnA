class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.includes(:user).find_each do |subscription|
      next if subscription.user.author?(answer)

      NewAnswerMailer.new_answer(subscription.user, answer).deliver_later
    end
  end
end
