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
  	
  	@order = Order.where("order_num = ? ",params[:order_num]).take
  	if(@order.nil?)
  		flash[:error] = "The order number is invalid";
  		redirect_to action:"index", controller:"returns"
  	end
  	valid_items = true;
  	@order_items = OrderItem.find(params[:order_item])
  	@order_items.each do |item|
  		if item[:order_id]!=@order[:id]
  			valid_items = false;
  		end
  	end

  	if(!valid_items)
  		flash[:error] = "some selected items are invalid for the order "+params[:order_num]
  		#render :to_step_1 #this will be used in case we want to redirect
  		render :order_num
  	end


  end #end validate_step_one

  
end
