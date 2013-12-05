class HallistsController < ApplicationController
  def index
    set_filters
    search = User.filters(params[:filters] || {}, params[:page])
    if search.hits.size == 1
      puts 'filtro igual a 1'
      redirect_to UserDecorator.decorate(search.results.first).profile_path
    else
      puts 'entro al else'
      @hallists = UserDecorator.decorate(search.results).map(&:hallist_to_json)
      puts 'hallissttt' + @hallists.to_yaml
      respond_to do |format|
        format.html
        format.json { render json: @hallists }
      end
    end
  end
  
  private
  
  def set_filters
    params[:filters] = {} if params[:filters].nil?
    params[:filters][:search] = params[:search_term] if params[:search_term].present?
    params[:filters][:artist] = false
  end
end
