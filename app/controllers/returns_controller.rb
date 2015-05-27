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
	  	return_items = params[:order_items]
	  	@order_items = OrderItem.find(return_items)
	  	@counts = Hash.new(0)
	  	return_items.each {|oid| @counts[oid]+=1}
	  	

	  	errors = Array.new
	  	# only return amount for items that want to be returned, 
	  	# since array contains all order item keys regardless if they want to be returned or not
	  	#amount_to_return = params[:amount_to_return].delete_if {|k,v| return_items.keys.index(k).nil?}

	  	@order_items.each do |item|
	  		# make sure order item exists for the order
	  		if item[:order_id]!=@order[:id] && valid_items 
	  			valid_items = false;
	  			render_order_num = true;
	  			errors << "some selected items do not exist for the order "+params[:order_num]
	  		end
	  		# make sure number of items to be returned is less than or equal to the quantity bought minus items already returned for the same product
	  		if (item.quantity-item.amount_returned)<@counts[item[:id]]
	  			errors << "invalid quantity amount for " + item[:product_name];
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
	  	flash[:order_num] = params[:order_num]
  		flash[:order_item] = params[:order_item]
  		#flash[:return_type] = params[:return_type]
  		#flash[:other_size] = params[:other_size]
  		#flash[:amount_to_return] = params[:amount_to_return]


	end #end validate_step_one

	def validate_final_step

	end

	def final_step

		#options for review
	 	@options = ReturnReasonAttribute.where("parent_id=?",0)

		return_items = Array.new
		@all_errors = Array.new
		@order = Order.find(params[:order_id])
		return_order = ReturnOrders.new(order_id: params[:order_id],order_num: params[:order_num],return_status: 0)

		return_items = params[:order_items]
		@order_items = OrderItem.find(params[:order_items])

		@counts = Hash.new(0)
	  	return_items.each {|oid| @counts[oid]+=1}
	  	
	  	return_attributes = params[:return_attributes]
	  	

		total_amount = 0.00;
		order_items_to_save = []
		@order_items.each do |item|

			if(@counts[item[:id]] > item[:quantity]-item[:amount_returned])
				@all_errors << "invalid quantity amount returned for product " + item[:product_name]
				break 
			end
			#iterate depending on how many they choose to return of the same product
			(1..@counts[item[:id].to_s]).to_a.each do |times| 
				return_item = ReturnItems.new(order_num: @order[:order_num],
					order_id: @order[:id], product_name: item[:product_name],
					return_type: 1, return_reasons: "",
					amount_refunded: item[:price], original_size: item[:size], new_size: "",
					status: "pending", quantity: 1)
				#for each attribute selected for this product
				if(!return_attributes[item[:id].to_s][times.to_s].nil?)
					return_attributes[item[:id].to_s][times.to_s].each do |attr_id|
						return_item.return_order_attributes << ReturnOrderAttribute.new(return_reason_attribute_id: attr_id)
					end
				end

				return_order.return_items << return_item
				total_amount += item[:price]
			end

			# if no break then that means ther where no errors
			item[:amount_returned] = @counts[item[:id].to_s]
			order_items_to_save << item
			
			
		end
		
		return_order[:amount_refunded] = total_amount
		#render json: return_order and return
		#@option_attributes = ReturnReasonAttribute.find(params[:return_attributes])
		#@option_attributes.each do |item|
		#	return_order.return_order_attributes << ReturnOrderAttribute.new(return_reason_attrbiute_id: item[:id])
		#end

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

		@return_order_attributes = ReturnOrderAttribute.all
		
	end

	def truncate_tables
		tables = ['return_items','return_order_attributes','return_orders','return_reason_attributes',
			'order_items','orders']

		tables.each do |table|
			ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
			ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{table}'")
		end

	end

  
end
