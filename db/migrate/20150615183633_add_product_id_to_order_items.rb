class AddProductIdToOrderItems < ActiveRecord::Migration
  def up
  	add_column :order_items, :product_id, :integer, :references =>"products"
  	add_column :products, :image_front, :string
  	add_column :products, :image_back, :string

  end

  def down
  	remove_column :order_items, :product_id
  	remove_column :products, :image_front
  	remove_column :products, :image_back
  end
end
