class SearchController < ApplicationController
  skip_authorization_check

  def show
    @results = SearchService.new(params[:query], params[:resource]).call
  end
end
