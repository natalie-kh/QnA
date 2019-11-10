class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates_uniqueness_of :question_id, if: :validate_uniqueness_of_accepted_answer

  default_scope { order(accepted: :desc) }

  def accept!
    question.answers.update_all(accepted: false)

    self.update!(accepted: true)
  end

  def validate_uniqueness_of_accepted_answer
    accepted? && question.answers.find_by(accepted: true)
  end
end
