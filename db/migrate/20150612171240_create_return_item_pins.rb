class CreateReturnItemPins < ActiveRecord::Migration
  def change
    create_table :return_item_pins do |t|
      t.integer :return_item_id
      t.float :pos_x
      t.float :pos_y
      t.float :radius
      t.float :canvas_width
      t.float :canvas_height
      t.belongs_to :pin_attribute_id, index: true
      t.string :image_type

      t.timestamps
    end
  end
end
