class AddStatusToOrderItems < ActiveRecord::Migration
  def up
  	change_table :order_items do |t|
  		t.string :status
  		t.integer :amount_returned
  	end
  end

  def down
  	change_table :order_items do |t|
  		t.remove :status
  		t.remove :amount_returned
  	end
  end
end
