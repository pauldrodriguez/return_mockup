class AddParentIdToPinAttributes < ActiveRecord::Migration
  def up
    add_column :pin_attributes, :parent_id, :integer
    #add_column :pin_attributes, :attribute_type, :string
  end

  def down
  	remove_column :pin_attributes, :parent_id
  	#remove_column :pin_attributes, :attribute_type
  end
end
