class AddCountryAndStateToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :country, :string
    add_column :addresses, :state, :string
    remove_column :addresses, :state_id
    remove_column :addresses, :state_name
  end
end
