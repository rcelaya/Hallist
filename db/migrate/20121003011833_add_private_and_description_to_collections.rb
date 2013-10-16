class AddPrivateAndDescriptionToCollections < ActiveRecord::Migration
  def change
    add_column :collections, :private, :boolean
    add_column :collections, :description, :string
  end
end
