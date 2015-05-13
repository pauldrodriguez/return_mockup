class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :order_num
      t.decimal :amount
      t.string :first_name
      t.string :last_name
      t.decimal :discounts
      t.decimal :tax
      t.decimal :subtotal

      t.timestamps
    end
  end
end
