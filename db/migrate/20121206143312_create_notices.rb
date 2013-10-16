class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.text :content
      t.boolean :active
      t.string :background_color
      t.string :color

      t.timestamps
    end
  end
end
