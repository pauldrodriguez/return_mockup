class AttributesController < ApplicationController
	def index
		@attributes = ReturnReasonAttribute.all
	end


	def new
		@attribute = ReturnReasonAttribute.new
		@parent_attributes = ReturnReasonAttribute.where("parent_id=?",0)
	end


	def edit
		@attribute = ReturnReasonAttribute.find(params[:id])
		@parent_attributes = ReturnReasonAttribute.where("parent_id=? and id!=?",0,params[:id])
		
	end


	def create
		@attribute = ReturnReasonAttribute.new(strong_params)
		if(@attribute.parent_id=="" || @attribute.parent_id.nil?)
			@attribute.parent_id = 0;
		end
		@attribute.code_name = @attribute.attr_name.gsub(/[^A-Za-z0-9]/i,"")
		if(@attribute.save)
			redirect_to attributes_path
		else
			redirect_to new_attributes_path(@attribute)
		end
	end


	def update
		@attribute = ReturnReasonAttribute.find(params[:id])
		@attribute.assign_attributes(strong_params)

		if(@attribute.parent_id=="" || @attribute.parent_id.nil?)
			@attribute.parent_id = 0;
		end
		@attribute.code_name = @attribute.attr_name.gsub(/[^A-Za-z0-9]/i,"")
		if(@attribute.save)
			redirect_to attributes_path
		else
			redirect_to new_attributes_path(@attribute)
		end

	end


	def all
		@attributes = ReturnReasonAttribute.all
	end


	private

	def strong_params
		params.require(:return_reason_attribute).permit(:attr_name, :parent_id,:display_order,:attr_type)
	end
end