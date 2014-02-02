class ArtistsController < ApplicationController
  
  def index
    set_filters
    search = User.filters(params[:filters] || {}, params[:page])
    #puts search.to_yaml + 'search'
    if search.hits.size == 1
      redirect_to UserDecorator.decorate(search.results.first).profile_path
    else
      @artists = UserDecorator.decorate(search.results).map(&:artist_to_json)
      respond_to do |format|
        format.html
        format.json { render json: @artists }
      end
    end
  end
  
  private
  
  def set_filters
    params[:filters] = {} if params[:filters].nil?
    params[:filters][:search] = params[:search_term] if params[:search_term].present?
    params[:filters][:artist] = true
  end
end
