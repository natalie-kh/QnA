class SearchController < ApplicationController
  skip_authorization_check

  def show
    @results = SearchService.call(query: params[:query], resource: params[:resource])
  end
end
