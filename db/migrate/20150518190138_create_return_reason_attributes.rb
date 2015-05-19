class CreateReturnReasonAttributes < ActiveRecord::Migration
  def change
    create_table :return_reason_attributes do |t|
      t.integer :parent_id
      t.string :code_name
      t.string :attr_name
      t.integer :display_order
      t.integer :attr_type
    end
  end
end
