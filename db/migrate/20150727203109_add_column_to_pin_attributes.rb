class AddColumnToPinAttributes < ActiveRecord::Migration
  def up
  	add_column :pin_attributes, :fill, :string
  end
  def down
  	remove_column :pin_attributes, :fill
  end
end
