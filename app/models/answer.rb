class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true
  validates :accepted, uniqueness: { scope: :question_id, accepted: true }, if: :accepted?

  default_scope { order('accepted DESC, created_at') }

  def accept!
    transaction do
      question.answers.update_all(accepted: false)

      self.update!(accepted: true)
      question.award&.update!(user: user)
    end
  end
end
