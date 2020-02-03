class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def commentable_klass
    @commentable_klass = params[:question_id] ? Question : Answer
  end

  def load_commentable
    @commentable = commentable_klass.find(params["#{@commentable_klass.name.underscore}_id"])
  end
end
