class ReturnOrderAttribute < ActiveRecord::Base
	belongs_to :return_reason_attribute, class_name: "ReturnReasonAttribute",foreign_key: "return_reason_attrbiute_id"

	
end