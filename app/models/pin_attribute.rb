class PinAttribute < ActiveRecord::Base
	has_many :child_attributes, :class_name=> "PinAttribute", :foreign_key=>"parent_id"
end
