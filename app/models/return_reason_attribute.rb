class ReturnReasonAttribute < ActiveRecord::Base
	has_many :child_attributes, :class_name=> "ReturnReasonAttribute", :foreign_key=>"parent_id", :order=>"display_order ASC"
	validates :attr_type, :inclusion => 1..2
end