class Api::V1::QuestionsController < Api::V1::BaseController
  include Rails.application.routes.url_helpers

  before_action :load_question, only: %i[update destroy]

  authorize_resource

  def index
    @questions = Question.includes(:user, :answers).all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.with_attached_files.find(params['id'])
    render json: @question, serializer: QuestionSerializer
  end

  def create
    @question = current_resource_owner.questions.create!(question_params)
    render json: @question, status: :created
  end

  def update
    @question.update!(question_params)
  end

  def destroy
    @question.destroy!
  end

  def answers
    @answers = Answer.includes(:user).where(question_id: params['id'])
    render json: @answers, each_serializer: AnswersSerializer
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                     links_attributes: %i[name url])
  end
end
