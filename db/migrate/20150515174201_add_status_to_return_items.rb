class AddStatusToReturnItems < ActiveRecord::Migration
  def up
  	change_table :return_items do |t|
  		t.string :status
  		t.integer :quantity
      t.integer :return_order_item_id
  	end
  	change_column :return_items, :product_name, :string
  	change_column :return_items, :amount_refunded, :decimal
  end

  def down
  	change_table :return_items do |t|
  		t.remove :status
  		t.remove :quantity
      t.remove :return_order_item_id
  	end
  	change_column :return_items, :product_name, :integer
  	change_column :return_items, :amount_refunded, :integer
  end
end
