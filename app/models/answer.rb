class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  after_commit :send_new_answer, on: :create

  belongs_to :question, touch: true
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true
  validates :accepted, uniqueness: { scope: :question_id, accepted: true }, if: :accepted?

  default_scope { order('accepted DESC, created_at') }

  def accept!
    transaction do
      question.answers.update_all(accepted: false)

      update!(accepted: true)
      question.award&.update!(user: user)
    end
  end

  def send_new_answer
    NewAnswerJob.perform_later(self)
  end
end
