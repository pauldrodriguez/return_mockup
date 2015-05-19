class ReturnItems < ActiveRecord::Base
	belongs_to :return_orders, class_name: "ReturnOrders", foreign_key: "return_order_id"
end
