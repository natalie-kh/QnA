class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  private

  def current_resource_owner
    if doorkeeper_token
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
    end
  end

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end
