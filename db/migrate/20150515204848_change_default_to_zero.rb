class ChangeDefaultToZero < ActiveRecord::Migration
  def up
  	change_column :order_items, :amount_returned, :integer, :null=>false, :default=>0
  end

  def down
  	#raise ActiveRecord::IrreversibleMigration, "Can't remove the default"
  end
end
