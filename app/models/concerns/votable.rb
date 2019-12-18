module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable

    def rating
      votes.sum(:value)
    end

    def vote!(user, value)
      transaction do
        votes.where(user_id: user.id).delete_all
        votes.create(user: user, value: value)
      end
    end
  end
end
