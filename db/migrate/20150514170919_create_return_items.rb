class CreateReturnItems < ActiveRecord::Migration
  def change
    create_table :return_items do |t|
      t.integer :return_order_id
      t.integer :order_num
      t.integer :order_id
      t.integer :product_name
      t.integer :return_type
      t.string :return_reasons
      t.integer :amount_refunded
      t.string :original_size
      t.string :new_size

      t.timestamps
    end
  end
end
