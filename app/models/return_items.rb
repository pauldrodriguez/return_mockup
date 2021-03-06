class ReturnItems < ActiveRecord::Base
	belongs_to :return_orders, class_name: "ReturnOrders", foreign_key: "return_order_id"
	belongs_to :order_item, class_name: "OrderItem",foreign_key: "order_item_id"
	has_many :return_order_attributes, class_name: "ReturnOrderAttribute", foreign_key: "return_item_id"

	has_many :return_item_pins, class_name: "ReturnItemPin", foreign_key: "return_item_id"
end
