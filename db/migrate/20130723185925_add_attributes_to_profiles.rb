class AddAttributesToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :website, :string
    add_column :profiles, :facebook, :string
    add_column :profiles, :twitter, :string
    add_column :profiles, :pinterest, :string
    add_column :profiles, :instagram, :string
  end
end
