class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :amount_cents
      t.integer :auction_id
      t.boolean :winner
      t.integer :user_id

      t.timestamps
    end
  end
end
