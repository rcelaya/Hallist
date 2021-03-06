## Inventory is a table that needs to have pestimistic locking.
#  This requires the SQL to be very fast in order to ensure the table is not locked.
#  Please keep the table free from extra data that might cause locking to become an issue.

class Inventory < ActiveRecord::Base
  has_one :variant
  has_many :accounting_adjustments, :as => :adjustable

  validates :count_on_hand,       :presence => true

  validate :must_have_stock


  private

    def must_have_stock
      @count_on_hand = count_on_hand.present? ? count_on_hand : 0
      @count_pending_to_customer = count_pending_to_customer.present? ? count_pending_to_customer : 0

      if (@count_on_hand - @count_pending_to_customer) <= 0
        errors.add :count_on_hand, 'There is not enough stock to sell this item'
      end
    end
end
