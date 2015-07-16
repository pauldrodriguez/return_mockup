class BoxArea < ActiveRecord::Base
	has_one :pin_attribute
	belongs_to :product
end
