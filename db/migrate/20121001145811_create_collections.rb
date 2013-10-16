class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :name
      t.integer :customer_id
      t.integer :user_id

      t.timestamps
    end
  end
end
