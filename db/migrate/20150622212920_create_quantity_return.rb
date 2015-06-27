class CreateQuantityReturn < ActiveRecord::Migration
  def up
    create_table :quantity_returns do |t|
		t.belongs_to :order
  		t.belongs_to :order_item
  		t.integer :quantity

  		t.timestamps
    end
  end

  def down
  	drop_table :quantity_returns
  end
end
