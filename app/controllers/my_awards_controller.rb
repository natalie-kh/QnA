class MyAwardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @my_awards = current_user.awards.with_attached_image.includes(:question)
  end
end
