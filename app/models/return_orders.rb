class ReturnOrders < ActiveRecord::Base
	has_many :return_items, class_name: "ReturnItems", foreign_key: "return_order_id"
end
