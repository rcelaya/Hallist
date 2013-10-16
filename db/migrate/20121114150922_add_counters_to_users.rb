class AddCountersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sells_counter, :integer, null: false, default: 0
    add_column :users, :shoppings_counter, :integer, null: false, default: 0
  end
end
