class AddArtistBooleanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :artist, :boolean
    add_column :users, :enable_to_sell, :boolean
  end
end
