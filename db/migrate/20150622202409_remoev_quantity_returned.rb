class RemoevQuantityReturned < ActiveRecord::Migration
  def up
  	drop_table :order_item_quantity_returned
  end
end
