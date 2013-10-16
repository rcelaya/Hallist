class AddLikesCounterToProducts < ActiveRecord::Migration
  def change
    add_column :products, :likes_count, :integer, null: false, default: 0
  end
end
