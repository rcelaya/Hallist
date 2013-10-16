class AddCartItemsCountToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :cart_items_count, :integer, null: false, default: 0
  end
end
