class ReturnsController < ApplicationController
	protect_from_forgery :only=>[:order_num,:review,:final_step,:success]
	def index
		session.delete(:order_num)
	end

	def order_num
		if(params.has_key?(:order_num))
			order_number = params[:order_num]
		elsif(session.has_key?(:order_num))
			order_number = session[:order_num]
		else
			order_number = 0;
		end

	  	@order = Order.where("order_num = ?", params[:order_num]).take
	  
	  	if(@order.nil?)
	  		flash[:error] = "The order number is invalid"
	  		redirect_to action:"index", controller:"returns" and return
  			#add another check for when time of when order was created is more than 40 days
  			#add another check if all items have been returned
		elsif (DateTime.now.to_date-@order[:created_at].to_date).to_i > 40
			flash[:error] = "You cannot return items for orders older than 40 days"
			redirect_to action:"index", controller:"returns" and return
  		else
  			can_continue = false
  			# in here, want to get all items that have been put for return and all items that have shipped to compare
  			return_items_temp = ReturnItems.select("return_items.order_item_id").where("order_num=?",params[:order_num]).group(:order_item_id).count
  			@order.order_items.each do |obj|
  				if(return_items_temp.has_key?(obj[:id]))
	  				if(obj[:quantity] - return_items_temp[obj[:id]] > 0)
	  					can_continue = true
	  					break
	  				end
  				elsif obj[:quantity]>0
  					can_continue = true
  					break

  				end
  			end

  			if(!can_continue)
  				flash[:error] = "there are no more items to return"
  				redirect_to action: "index", controller: "returns" and return
  			end
  			#ReturnItems.select("return_items.order_item_id,order_items.quantity").where("return_items.order_num=?",params[:order_num]).joins(:order_item).group("return_items.order_item_id").count("return_items.order_item_id")
	  	end

	  	# if everything is valid, then we should be able to get here

	  	#save order number in session
	  	session[:order_num] = params[:order_num]

  	end
  	def validate_orders
  		errors = Array.new
 		#@options = ReturnReasonAttribute.where("parent_id=?",0)
  		#make sure order number was passed
  		if(!session.has_key?(:order_num))
  			errors << "the order number is invalid."
  			flash[:errors] = errors
  			redirect_to actionL "index",controller: "returns" and return
  		end

	  	@order = Order.where("order_num = ? ",session[:order_num]).take
	  	if(@order.nil?)
	  		errors << "The order number is invalid."
	  		flash[:errors] = errors
	  		redirect_to action:"index", controller:"returns" and return
	  	end

	  	if(params[:order_items].empty?)
	  		errors << "you must select at least one item to return"
	  		flash[:errors] = errors
	  		redirect_to action:"order_num", controller:"returns" and return
	  	end

	  	redirect_back = false;
	  	valid_items = true;
	  	#only want the items that actually have a value in them
	  	return_order_items = params[:order_items]
	  	@order_items = OrderItem.find(return_order_items)

	  	@counts = Hash.new(0)
	  	return_order_items.each {|oid| @counts[oid.to_i]+=1}
	  	
	  	#gets all the returned items for the order
	  	@return_items = ReturnItems.select("return_items.order_item_id").where("order_num=?",session[:order_num]).group(:order_item_id).count
	  	
	  	# only return amount for items that want to be returned, 
	  	# since array contains all order item keys regardless if they want to be returned or not
	  	#amount_to_return = params[:amount_to_return].delete_if {|k,v| return_items.keys.index(k).nil?}

	  	@order_items.each do |item|
	  		# make sure order item exists for the order
	  		if item[:order_id]!=@order[:id] && valid_items 
	  			valid_items = false;
	  			redirect_back = true;
	  			errors << "some selected items do not exist for the order "+session[:order_num]
	  		end
	  		# make sure number of items to be returned is less than or equal to the quantity bought minus items already returned for the same product
	  		if (item[:quantity] - (@return_items[item[:id]] || 0) ) < @counts[item[:id]]
	  			errors << "invalid quantity amount for " + item[:product_name];
	  			redirect_back = true
	  		end
	  	end

	  	if(return_order_items.empty?)
	  		errors << "you must select at least one item to return"
	  		redirect_back = true;
	  	end
	  	
	  	#render_order_num = true;
	  	if(redirect_back)
	  		flash[:errors] = errors
	  		#render :to_step_1 #this will be used in case we want to redirect
	  		redirect_to action:"order_num",controller:"returns" and return
	  	end
	  	# order items have been validated, store in session
	  	session[:order_items_count] = @counts
	  	session[:return_items] = return_order_items
	  	session[:review_redirect] = true
	  	redirect_to action:"review",controller:"returns" and return
  	
  	end

	def review

  		@options = ReturnReasonAttribute.where("parent_id=?",0)

  		@attributes = PinAttribute.includes([:child_attributes]).where("parent_id=?",0)

  		#make sure order number was passed
  		if(!session.has_key?(:order_num))
  			flash[:error] = "the order number is invalid."
  			redirect_to action: "index",controller: "returns" and return
  		end

	  	@order = Order.where("order_num = ? ",session[:order_num]).take
	  	if(@order.nil?)
	  		flash[:error] = "The order number is invalid."
	  		redirect_to action:"index", controller:"returns" and return
	  	end

	  	if(session.has_key?(:review_redirect) && session[:review_redirect]==true) || session.has_key?(:return_items)
	  		#oiid, tqtynum = session[:order_items_count].first
	  		session.delete(:review_redirect)
	  	else
	  	
	  		redirect_to action:"index", controller: "returns" and return
	  	end
	  	#render_order_num = false;
	  	#valid_items = true;
	  	#only want the items that actually have a value in them
	  	#return_items = params[:order_items]
	  	@order_items = OrderItem.find(session[:return_items])
	  	@counts = session[:order_items_count]
	  	@inches = Array.new
	  	@inches << ["Inches",0]
	  	(1..12).to_a.each {|inch| @inches << [inch,inch]} 
		#@inches = (1..12).to_a
		@feet  = [["Feet",0]]
		(1..7).to_a.each {|feet| @feet << [feet,feet]}


	end #end validate_step_one

	def validate_final_step

	end




	def final_step
		if(params.has_key?(:pin_attributes))
			pin_attributes = params[:pin_attributes]
		else
			pin_attributes = Hash.new
		end
		
		return_attributes = params[:return_attributes]
		@return_attributes_ids = []
		return_attributes.each do |key,list|
			list.each do |skey, slist|
				@return_attributes_ids += slist.map(&:to_i)
			end
		end
		# need to find out if they chose fit issues checkbox so we can render the checkbox
		#@reasons_selected = ReturnReasonAttribute.where("id IN (:ids) and code_name = :cd",{ids: @return_attributes_ids,cd: "fitissues"})
		#if(@reasons_selected.any? && !params.has_key?("fit_change_submit"))
		#	render :fit_issues and return
		#end
		#options for review
	 	@options = ReturnReasonAttribute.where("parent_id=?",0)

	 	heel_height = (params.has_key?(:heel_height)) ? params[:heel_height] : 0;
	 	height_feet = (params.has_key?(:feet)) ? params[:feet] : 0
	 	height_inches = (params.has_key?(:inches)) ? params[:inches] : 0

		return_items = Array.new
		@all_errors = Array.new
		@order = Order.find(params[:order_id])
		return_order = ReturnOrders.new(order_id: params[:order_id],order_num: params[:order_num],
			return_status: 0, heel_height: heel_height, height_feet: height_feet, height_inches: height_inches)

		return_items = params[:order_items]
		@order_items = OrderItem.find(params[:order_items])

		@counts = Hash.new(0)
	  	return_items.each {|oid| @counts[oid]+=1}
	  	
	  	
	  	

		total_amount = 0.00;
		#order_items_to_save = []
		@order_items.each do |item|
			iid = item[:id].to_s
			if(@counts[item[:id].to_s] > item[:quantity])
				@all_errors << "invalid quantity amount returned for product " + item[:product_name]
				break 
			end
			#iterate depending on how many they choose to return of the same product
			(1..@counts[item[:id].to_s]).to_a.each do |times| 
				return_item = ReturnItems.new(order_num: @order[:order_num],
					order_id: @order[:id], product_name: item[:product_name],
					amount_refunded: item[:price],
					status: "pending", quantity: 1,order_item_id: item[:id])
				#for each attribute selected for this product
				if(!return_attributes[iid][times.to_s].nil?)
					return_attributes[item[:id].to_s][times.to_s].each do |attr_id|
						return_item.return_order_attributes << ReturnOrderAttribute.new(return_reason_attribute_id: attr_id)
					end
				end
				if (pin_attributes.has_key?(iid))
					if(pin_attributes[iid].has_key?(times.to_s))

						if(pin_attributes[iid][times.to_s].has_key?(:front))
							pin_attributes[iid][times.to_s][:front].each do |pin|
								pin_arr = pin.split("_")
								# after splitting, the array must be length of 6
								if(pin_arr.length==6) 
									return_item.return_item_pins << ReturnItemPin.new(pos_x: pin_arr[1],
										pos_y: pin_arr[2],
										radius: pin_arr[3],pin_attribute_id_id: pin_arr[0],
										canvas_width: pin_arr[4], canvas_height: pin_arr[5], image_type: "front")
								end
							end
						end

						if(pin_attributes[iid][times.to_s].has_key?(:back))
							pin_attributes[iid][times.to_s][:back].each do |pin|
								pin_arr = pin.split("_")
								# after splitting, the array must be length of 6
								if(pin_arr.length==6) 
									return_item.return_item_pins << ReturnItemPin.new(pos_x: pin_arr[1],
										pos_y: pin_arr[2],
										radius: pin_arr[3],pin_attribute_id_id: pin_arr[0],
										canvas_width: pin_arr[4], canvas_height: pin_arr[5], image_type: "back")
								end
							end
						end

						#return_item.return_item_pins << ReturnItemPin.new()
					end
				end

				return_order.return_items << return_item
				total_amount += item[:price]
			end

			# if no break then that means there where no errors
			#item[:amount_returned] += @cofunts[item[:id].to_s]
			#order_items_to_save << item
			
			
		end
		
		return_order[:amount_to_refund] = total_amount
	

		if(@all_errors.length<=0)
			if(return_order.save)
				return_order.save

				#OrderItem.transaction do
				#	order_items_to_save.each(&:save)
				#end
				flash[:csrf_token] = params[:authenticity_token]
				redirect_to success_returns_path(:roid=>return_order[:id], :authenticity_token=>params[:authenticity_token])
			else
				#redirect_to all_returns_returns_path
			end
		else
			render :review
		end
		

	end

	def success
		
		#if(params.has_key?(:roid) && params.has_key?(:authenticity_token) && flash.key?(:csrf_token))
		#	if(params[:authenticity_token]!=flash[:csrf_token] || !ReturnOrders.exists?(params[:roid]))
		#		redirect_to all_returns_returns_path
				#@msg = "invalid return order id or csrf token"
		#	end
		#session.delete(:csrf_token)
		#else
		#	redirect_to all_returns_returns_path
			#@msg = "invalid params"
		#end
		flash[:referrer] = "success"
	end


	def success_confirmation
		if(flash[:referrer]) && (flash[:referrer]=="success")
			#do something
		else
			redirect_to all_returns_returns_path and return
		end
	end

	def canvas_test

		
	end

	def return_orders
		@return_orders = ReturnOrders.all
	end

	def show
		@return_order = ReturnOrders.find(params[:id])
	end

	def all_returns
		@return_orders = ReturnOrders.all
		@return_items = ReturnItems.all
		

		@orders = Order.all

		@order_items = OrderItem.all

		@return_order_attributes = ReturnOrderAttribute.all

		@return_item_pins = ReturnItemPin.all	
		
	end

	def truncate_tables
		tables = ['return_items','return_order_attributes','return_orders',
			'order_items','orders','return_item_pins','products']

		tables.each do |table|
			ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
			#case self.connection.adapter_name
      		#	when 'MySQL'
        			#self.connection.execute "ALTER TABLE #{self.table_name} AUTO_INCREMENT=#{options[:to]}"
      		#	when 'PostgreSQL'
        	#		ActiveRecord::Base.connection.execute "ALTER SEQUENCE #{table}_id_seq RESTART WITH 1;"
      		#	when 'SQLite'
        	#		ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{table}'")
      		#else
    
			
		end

	end
  
end