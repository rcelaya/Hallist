class FollowsController < ApplicationController
  
  def create
    @artist = User.find params[:artist_id]
    #if current_user != @artist
      current_user.follow!(@artist)
    #end
  end
  
  def destroy
    @artist = User.find params[:artist_id]
    #if current_user != @artist
      current_user.unfollow!(@artist)
    #end
  end
end
