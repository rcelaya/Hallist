class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.integer :product_id
      t.datetime :deadline
      t.boolean :active
      t.datetime :finished_at
      t.integer :minimum_bid_cents

      t.timestamps
    end
  end
end
