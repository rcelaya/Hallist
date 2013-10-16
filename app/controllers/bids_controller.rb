class BidsController < ApplicationController
  
  def create
    auction = Auction.find(params[:bid][:auction_id])
    @bid = current_user.user.bids.create(params[:bid]) if auction.active && auction.open?
  end
end
