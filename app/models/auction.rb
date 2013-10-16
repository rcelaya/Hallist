class Auction < ActiveRecord::Base
  
  #
  # Associations
  #
  belongs_to :product
  has_many :bids
  
  #
  # Accessors
  #
  attr_accessible :deadline, :product_id, :minimum_bid
  
  def minimum_bid=(amount)
    self.minimum_bid_cents = (amount.to_i*100)
  end
  
  def minimum_bid
    (self.minimum_bid_cents.to_i/100)
  end
  
  def finished?
    deadline <= Time.now
  end
  
  def open?
    !finished?
  end
  
  def winner
    bids.where(winner: true).first
  end
  
  def pick_winner_bid
    bid = bids.order('amount_cents DESC').limit(1).first
    bid.winner = true
    bid.save
  end
  
  def close
    self.finished_at = Time.now
    pick_winner_bid
    save
  end
  
  def activate
    self.active = true
    save
  end
end