class CreateReturnOrders < ActiveRecord::Migration
  def change
    create_table :return_orders do |t|
      t.integer :order_num
      t.integer :order_id
      t.decimal :amount_refunded
      t.integer :return_status
      t.timestamps
    end
  end
end
