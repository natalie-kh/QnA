class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  after_create :create_subscription!

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_one :award, dependent: :destroy

  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :award, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  private

  def create_subscription!
    subscriptions.create!(user: user)
  end
end
