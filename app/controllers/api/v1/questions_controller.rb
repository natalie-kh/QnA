class Api::V1::QuestionsController < Api::V1::BaseController
  include Rails.application.routes.url_helpers

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.with_attached_files.find(params['id'])
    render json: @question, serializer: QuestionSerializer
  end
end
