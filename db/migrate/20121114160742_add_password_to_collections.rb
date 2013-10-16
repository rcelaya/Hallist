class AddPasswordToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :password, :string
  end
end
