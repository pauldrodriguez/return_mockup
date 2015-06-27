class Order < ActiveRecord::Base
	has_many :order_items
	has_many :quantity_returns

	def full_name
		self.first_name + " " + self.last_name
	end
end
