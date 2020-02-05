class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "/questions/#{params[:question_id]}/comments"
  end

  def unsubscribed; end
end
