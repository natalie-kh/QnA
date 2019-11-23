class MyAwardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @my_awards = current_user.awards
  end
end
