class FollowsController < ApplicationController
  
  def create
    @artist = User.find params[:artist_id]
    current_user.follow!(@artist)
  end
  
  def destroy
    @artist = User.find params[:artist_id]
    current_user.unfollow!(@artist)
  end
end
