class AddCollectionIdToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :collection_id, :integer
  end
end
