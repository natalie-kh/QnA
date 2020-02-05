class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[destroy update accept]
  after_action :publish_answer, only: :create

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @question = @answer.question

    @answer.update(answer_params) if current_user.author?(@answer)
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
    else
      redirect_to question_path(@answer.question), notice: 'You are not authorized for this.'
    end
  end

  def accept
    @question = @answer.question

    if current_user.author?(@question)
      @answer.accept!
    else
      redirect_to question_path(@question), notice: 'You are not authorized for this.'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast "/questions/#{@answer.question_id}/answers", @answer.to_json
  end
end
