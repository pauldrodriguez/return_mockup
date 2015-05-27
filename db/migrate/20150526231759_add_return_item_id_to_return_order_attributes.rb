class AddReturnItemIdToReturnOrderAttributes < ActiveRecord::Migration
  def up
  	add_column :return_order_attributes, :return_item_id, :integer
  	rename_column :return_order_attributes, :return_reason_attrbiute_id, :return_reason_attribute_id
  	remove_column :return_order_attributes, :return_order_id, :integer
  end

  def down

  end
end
