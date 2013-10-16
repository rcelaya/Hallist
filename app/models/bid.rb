class Bid < ActiveRecord::Base
  attr_accessible :amount_cents, :auction_id, :user_id, :winner, :amount
  
  def amount=(bid_amount)
    self.amount_cents = (bid_amount.to_i*100)
  end
  
  def amount
    (self.amount_cents.to_i/100)
  end
end
