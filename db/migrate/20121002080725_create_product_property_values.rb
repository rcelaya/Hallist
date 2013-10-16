class CreateProductPropertyValues < ActiveRecord::Migration
  def change
    create_table :product_property_values do |t|
      t.integer :product_id
      t.integer :property_value_id

      t.timestamps
    end
  end
end
