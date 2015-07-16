class CreateBoxAreas < ActiveRecord::Migration
  def change
    create_table :box_areas do |t|
      t.float :posx
      t.float :posy
      t.float :width
      t.float :height
      t.float :canvas_width
      t.float :canvas_height
      t.string :fill
      t.integer :group_id
      t.integer :product_id
      t.string :type
      t.timestamps
    end
  end
end
