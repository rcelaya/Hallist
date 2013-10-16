class AddSettingsToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :settings, :text
  end
end
