module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable

    def rating
      votes.sum(:value)
    end

    def vote!(user, vote_value: value )
      transaction do
        votes.where(user_id: user.id).delete_all
        votes.create!(user: user, value: vote_value)
      end
    end
  end
end
