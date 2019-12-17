module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable

    def vote_for!(user)
      vote(user, 1)
    end

    def vote_against!(user)
      vote(user, -1)
    end

    def rating
      votes.sum(:value)
    end

    private

    def vote(user, value)
      transaction do
        votes.where(user_id: user.id).delete_all
        votes.create(user: user, value: value)
      end
    end
  end
end
