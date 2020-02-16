class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :load_subscription, only: :show
  after_action :publish_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    gon.question_user_id = @question.user_id
    gon.question_id = @question.id
  end

  def new
    @question = Question.new
    @question.build_award
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Your question successfully deleted.'
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[id name url _destroy],
                                                    award_attributes: %i[name image])
  end

  def load_subscription
    @subscription = @question.subscriptions.find_by(user: current_user)
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions_channel',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end
end
