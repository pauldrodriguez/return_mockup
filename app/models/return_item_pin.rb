class ReturnItemPin < ActiveRecord::Base
	belongs_to :return_item, class_name: "ReturnItems", foreign_key: "return_item_id"
	belongs_to :pin_attribute, foreign_key: "pin_attribute_id_id"
end
