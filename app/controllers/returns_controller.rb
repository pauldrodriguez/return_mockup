class ReturnsController < ApplicationController
	def index

	end

	def order_num
	  	@order = Order.where("order_num = ?", params[:order_num]).take
	  
	  	if(@order.nil?)
	  		flash[:error] = "The order number is invalid";
	  		redirect_to action:"index", controller:"returns"
	  	end
  	end

	def review

  		@options = ReturnReasonAttribute.where("parent_id=?",0)

	  	@order = Order.where("order_num = ? ",params[:order_num]).take
	  	if(@order.nil?)
	  		flash[:error] = "The order number is invalid";
	  		redirect_to action:"index", controller:"returns"
	  	end

	  	render_order_num = false;
	  	valid_items = true;
	  	#only want the items that actually have a value in them
	  	return_items = params[:return_type].delete_if {|k,v| v!="1" && v!="2"}
	  	@order_items = OrderItem.find(return_items.keys)

	  	values = params[:return_type].values.uniq

	  	errors = Array.new
	  	# only return amount for items that want to be returned, 
	  	# since array contains all order item keys regardless if they want to be returned or not
	  	amount_to_return = params[:amount_to_return].delete_if {|k,v| return_items.keys.index(k).nil?}

	  	@order_items.each do |item|
	  		if item[:order_id]!=@order[:id] && valid_items
	  			valid_items = false;
	  			render_order_num = true;
	  			errors << "some selected items do not exist for the order "+params[:order_num]
	  		end

	  		if(amount_to_return.has_key?(item[:id].to_s))
	  			quantity = amount_to_return[item[:id].to_s].to_i

	  			# this step will probably be avoided if in database we can insetrt default value to 0
	  			if item[:amount_returned].nil?
	  				amount_returned = item[:amount_returned]
	  			else
	  				amount_returned = 0
	  			end
	  			if (quantity.nil?)
	  				errors << "invalid quantity value for product " + item[:product_name]
	  				render_order_num = true
	  			elsif (quantity>(item[:quantity] - amount_returned ) || quantity<1)
					errors << "invalid quantity value for product " + item[:product_name]
	  				render_order_num = true
	  			end
	  		else
	  			errors << "you must choose a quantity for the item " + item[:product_name]
	  			render_order_num = true
	  		end
	  		#errors << item[:id]
	  		#errors << params[:return_type][item[:id].to_s]
	  		#this is to make sure that the size is set and it is correct
	  		if (params[:return_type][item[:id].to_s]=="2" && (!params[:other_size].has_key?(item[:id].to_s) || params[:other_size][item[:id].to_s]==""))
	  			#do nothing for now
	  			errors << "invalid size for the product " + item[:product_name]
	  			render_order_num = true
	  		
	  			
	  		end
	  	end

	  	if(return_items.empty?)
	  		errors << "you must select at least one item to return"
	  		render_order_num = true;
	  	end
	  	@all_errors = errors
	  	#render_order_num = true;
	  	if(render_order_num)
	  		#flash[:error] = errors
	  		#render :to_step_1 #this will be used in case we want to redirect
	  		render :order_num
	  	end

  		flash[:order_item] = params[:order_item]
  		flash[:return_type] = params[:return_type]
  		flash[:other_size] = params[:other_size]
  		flash[:amount_to_return] = params[:amount_to_return]


	end #end validate_step_one

	def validate_final_step

	end

	def final_step

		#options for review
	 	@options = ReturnReasonAttribute.where("parent_id=?",0)

		return_items = Array.new
		@all_errors = Array.new
		@order = Order.find(params[:order_id])
		return_order = ReturnOrders.new(order_id: params[:order_id],order_num: params[:order_num],amount_refunded: 0.00,return_status: 0)

		#return_order.save

		@order_items = OrderItem.find(params[:return_type].keys)
		total_amount = 0.00
		order_items_to_save = []
		@order_items.each do |item|

			type = params[:return_type][item[:id].to_s].to_i

			amount = 0.00
			size = ""
			quantity = params[:amount_to_return][item[:id].to_s].to_i
			quantity_flash = flash[:amount_to_return][item[:id].to_s].to_i
			#quantity submitted through form and quantity save from previous form need to match
			if(quantity!=quantity_flash || !quantity.is_a?(Integer) || !quantity_flash.is_a?(Integer))
				@all_errors << "quantity for product " + item[:product_name] + "does not match submitted quantity";
				break
			elsif quantity<1 || quantity>(item[:quantity]-item[:amount_returned])
				@all_errors << "invalid quantity for product " + item[:product_name]
			else
				item.amount_returned=quantity
			end
			# return type must be either refund(1) or exchange(2)
			if(type==1)
				total_amount += item[:price]
				amount = item[:price]
			elsif type==2
				size = params[:other_size][item[:id].to_s]
			else
				@all_errors << "you must either select return or exchange for product ' " + item[:product_name]+ "'"
			end
			#save return item
			if(type==1 || type==2)
				return_order.return_items << ReturnItems.new(order_num: @order[:order_num],
					order_id: @order[:id],product_name: item[:product_name],
					return_type: type,return_reasons: "",
					amount_refunded: amount,original_size: item[:size],new_size: size,
					status: "pending",quantity: quantity)

				order_items_to_save << item
			end
		end
		return_order.amount_refunded = total_amount

		@option_attributes = ReturnReasonAttribute.find(params[:return_attributes])
		@option_attributes.each do |item|
			return_order.return_order_attributes << ReturnOrderAttribute.new(return_reason_attrbiute_id: item[:id])
		end

		if(@all_errors.length<=0)
			return_order.save
			OrderItem.transaction do
				order_items_to_save.each(&:save)
			end

			redirect_to success_returns_path
			#return_items.each do |ri|
			#	ri.
			#	ri.save
			#end
		else
			render :review
		end
		

	end

	def success

	end

	def all_returns
		@return_orders = ReturnOrders.all
		@return_items = ReturnItems.all
		

		@orders = Order.all

		@order_items = OrderItem.all
		
	end

  
end
