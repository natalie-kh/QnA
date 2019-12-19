module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voted, only: :vote
  end

  def vote
    return head :forbidden if current_user.author?(@voted)

    @voted.vote!(current_user, vote_value: votes_params['value'])

    render json: { votable_type: @voted.class.to_s,
                   votable_id: @voted.id,
                   votes: @voted.rating }
  end

  private

  def votes_params
    params.require(:voted).permit(:value)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_voted
    @voted = model_klass.find(params[:id])
  end
end
