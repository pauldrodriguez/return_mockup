class AddHeightToReturnOrders < ActiveRecord::Migration
  def up
    add_column :return_orders, :height_feet, :integer
    add_column :return_orders, :height_inches, :integer
    add_column :return_orders, :heel_height, :integer
    #add_column :pin_attributes, :attribute_type, :string
  end

  def down
  	remove_column :return_orders, :height_feet
  	remove_column :return_orders, :height_inches
    remove_column :return_orders, :heel_height
  	#remove_column :pin_attributes, :attribute_type
  end
end
