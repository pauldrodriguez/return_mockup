class ChangeOrderItems < ActiveRecord::Migration
  def up
  	change_table :order_items do |t|
  		t.integer :order_id
  	end
  end

  def down
  	change_table :order_items do |t|
  		t.remove :order_id
  	end
  end
end
