class CreatePinAttributes < ActiveRecord::Migration
  def change
    create_table :pin_attributes do |t|
      t.string :name

      t.timestamps
    end
  end
end
