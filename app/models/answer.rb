class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  validates :body, presence: true
end
