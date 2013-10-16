class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :username
      t.date :birth_date
      t.text :about
      t.text :avatar
      t.integer :user_id

      t.timestamps
    end
  end
end
