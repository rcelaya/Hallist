class Profiles::CollectionsController < ApplicationController

  def index
    profile = Profile.find(params[:profile_id])
    user = profile.user
    collections = user.collections.page(params[:page]).per_page(3)
    collections = CollectionDecorator.decorate(collections).map(&:json_to_browse)
    respond_to do |format|
      format.json { render json: collections }
    end
  end

end
