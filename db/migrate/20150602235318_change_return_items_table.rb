class ChangeReturnItemsTable < ActiveRecord::Migration
  def up
  	rename_column :return_items, :return_order_item_id, :order_item_id
  	remove_column :return_items, :original_size, :string
  	remove_column :return_items, :new_size, :string
  	remove_column :return_items, :return_reasons, :string
  	remove_column :return_items, :return_type, :integer

  	rename_column :return_orders, :amount_refunded, :amount_to_refund

  	remove_column :order_items, :amount_returned, :integer
  	
  end
end
