class Order < ActiveRecord::Base
	has_many :order_items
	has_many :order_item_quantity_returned, :class_name=>"OrderItemQuantityReturned"

	def full_name
		self.first_name + " " + self.last_name
	end
end
