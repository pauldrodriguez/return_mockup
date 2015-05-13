class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :order_num
      t.text :product_name
      t.text :size
      t.integer :quantity
      t.decimal :original_price
      t.decimal :price
      t.integer :quantity

      t.timestamps
    end
  end
end
