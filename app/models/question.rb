class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user, optional: true

  validates :title, :body, presence: true
end
