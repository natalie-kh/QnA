class NewAnswerMailer < ApplicationMailer
  def new_answer(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email, subject: 'New answer for your question'
  end
end
