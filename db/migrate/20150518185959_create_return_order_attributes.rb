class CreateReturnOrderAttributes < ActiveRecord::Migration
  def change
    create_table :return_order_attributes do |t|
      t.integer :return_reason_attrbiute_id
      t.integer :return_order_id
    end
  end
end
