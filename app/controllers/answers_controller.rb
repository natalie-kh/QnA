class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[destroy update accept]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @question = @answer.question

    if current_user.author?(@answer)
      @answer.update(answer_params)
    else
      redirect_to question_path(@question), notice: 'You are not authorized for this.'
    end

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

    if current_user.author?(@answer.question)
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
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
