class ChangeNameOfType < ActiveRecord::Migration
  def change
  	rename_column :box_areas, :type, :area_box_type
  end
end
