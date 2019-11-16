class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true
  validates :accepted, uniqueness: { scope: :question_id, accepted: true }, if: :accepted?

  default_scope { order('accepted DESC, created_at') }

  def accept!
    transaction do
      question.answers.update_all(accepted: false)

      self.update!(accepted: true)
    end
  end
end
