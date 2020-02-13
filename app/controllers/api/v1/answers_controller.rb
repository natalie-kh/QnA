class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[destroy update]

  skip_before_action :verify_authenticity_token, only: %i[create update]

  authorize_resource

  def show
    answer = Answer.with_attached_files.find(params['id'])
    render json: answer, serializer: AnswerSerializer
  end

  def create
    answer = @question.answers.create!(answer_params.merge(user: current_resource_owner))
    render json: answer, status: :created
  end

  def update
    @answer.update!(answer_params)
    head :no_content
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require('answer').permit(:body, links_attributes: %i[name url])
  end
end
