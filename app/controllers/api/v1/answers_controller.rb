class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: %i[create index]
  before_action :load_answer, only: %i[show destroy update]

  authorize_resource

  def show
    render json: @answer
  end

  def index
    @answers = @question.answers.includes(:user)
    render json: @answers, each_serializer: AnswersSerializer
  end

  def create
    answer = @question.answers.create!(answer_params.merge(user: current_resource_owner))
    render json: answer, status: :created
  end

  def update
    @answer.update!(answer_params)
  end

  def destroy
    @answer.destroy!
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
