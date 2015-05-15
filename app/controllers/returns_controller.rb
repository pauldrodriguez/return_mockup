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

		

		#options for review
	  	@options = {1=>"Wrong item shipped",2=>"Not as pictured",3=>"I didn't like it",

	  		4=>{5=>'the fabric',6=>'the details',7=>'the style',8=>'the color',9=>'other'},
	  		10=>'I changed my mind',
	  		11=>"It didn't fit",
	  		12=>{13=>'Around the shoulder',14=>"around the waist",15=>"Arount the bust",16=>"around the hips"},
	  		17=>'Any comments?'}


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

	  	@order_items.each do |item|
	  		if item[:order_id]!=@order[:id] && valid_items
	  			valid_items = false;
	  			render_order_num = true;
	  			errors << "some selected items do not exist for the order "+params[:order_num]
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

	  	if(values.length==1 && values[0]=="")
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


	end #end validate_step_one

	def final_step
		@order = Order.find(params[:order_id])
		return_order = ReturnOrders.new(order_id: params[:order_id],order_num: params[:order_num],amount_refunded: 0.00,return_status: 0)
		return_order.save
		@order_items = OrderItem.find(params[:return_type].keys)
		total_amount = 0.00
		@order_items.each do |item|
			type = params[:return_type][item[:id].to_s].to_i
			amount = 0.00
			size = ""
			if(type==1)
				total_amount += item[:price]
				amount = item[:price]
			elsif type==1
				size = params[:other_size][item[:id].to_s]
			end
			#save return item
			if(type==1 || type==2)
				return_item = ReturnItems.create(return_order_id: return_order[:id],order_num: @order[:order_num],order_id: @order[:id],product_name: item[:product_name],return_type: type,return_reasons: params[:return_reasons].to_json,amount_refunded: amount,original_size: item[:size],new_size: size)
			end
		end
		return_order.amount_refunded = total_amount
		return_order.save

	end

	def all_returns
		@return_orders = ReturnOrders.all

		Rails.logger.debug("My object: #{@return_orders.inspect}")
		#render :text => @return_orders.inspect

		@orders = Order.all
		#render :text => @orders.inspect
	end

  
end
