class Api::V1::QuestionsController < Api::V1::BaseController
  include Rails.application.routes.url_helpers

  authorize_resource

  def index
    @questions = Question.includes(:user, :answers).all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.with_attached_files.find(params['id'])
    render json: @question, serializer: QuestionSerializer
  end

  def answers
    @answers = Answer.includes(:user).where(question_id: params['id'])
    render json: @answers, each_serializer: AnswersSerializer
  end
end
