class CreateOrderItemQuantityReturneds < ActiveRecord::Migration
  def change
    create_table :order_item_quantity_returned do |t|
      t.belongs_to :order
      t.belongs_to :order_item
      t.integer :quantity

      t.timestamps
    end
  end
end
