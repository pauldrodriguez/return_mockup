var CanvasCtrl = function(canvas_container) {
	var oThis = this;

	this.canvas_front_id = null;
	this.canvas_back_id = null;
	this.canvas_container = canvas_container;
	this.widthToHeight = 480/720;
	this.last_shown_width = null;
	this.last_shown_height = null;
	this.radius = 6;
	this.save_last_dim = function() {
		oThis.last_shown_width = parseFloat($("#"+oThis.canvas_front_id).attr("width"));
		oThis.last_shown_height = parseFloat($("#"+oThis.canvas_front_id).attr("height"));
	}

	this.set_canvas_dim = function() {
		if(oThis.last_shown_width!==null && oThis.last_shown_height!==null) {
			$("#"+oThis.canvas_front_id).attr("width",oThis.last_shown_width);
			$("#"+oThis.canvas_front_id).attr("height",oThis.last_shown_height);

			$("#"+oThis.canvas_back_id).attr("width",oThis.last_shown_width);
			$("#"+oThis.canvas_back_id).attr("height",oThis.last_shown_height);
		}
	}
	/**
	draws the images based on the order id 
	*/
	this.draw_images = function() {
		canvas_front = $("#"+oThis.canvas_front_id);
		canvas_back = $("#"+oThis.canvas_back_id);
		order_id = canvas_front.attr("data-order-item-id");
		if( !(order_id in window.images) ) {
			return;
		}
		canvas_front_width = canvas_front.attr("width");
		canvas_front_height = canvas_front.attr("height");
		canvas_front.css({"background":"url('"+window.images[order_id].front+"')","background-repeat":"no-repeat"});
		canvas_front.css({"background-size": canvas_front_width+"px "+canvas_front_height+"px"});

		canvas_back_width = canvas_back.attr("width");
		canvas_back_height = canvas_back.attr("height");
		canvas_back.css({"background":"url('"+window.images[order_id].back+"')","background-repeat":"no-repeat"});
		canvas_back.css({"background-size": canvas_back_width+"px "+canvas_back_height+"px"});
	

	};


	this.set_data = function(order_item_id,quantity_counter) {
		$("#"+oThis.canvas_front_id).attr("data-order-item-id",order_item_id);
		$("#"+oThis.canvas_front_id).attr("data-repeated-counter",quantity_counter);

		$("#"+oThis.canvas_back_id).attr("data-order-item-id",order_item_id);
		$("#"+oThis.canvas_back_id).attr("data-repeated-counter",quantity_counter);

		$("#fit-issues-box").attr("data-order-item-id",order_item_id);
		$("#fit-issues-box").attr("data-quantity-counter",quantity_counter);
	};

	this.clear_canvas = function() {
		var canvas_front = $("#"+oThis.canvas_front_id);
		var canvas_back =  $("#"+oThis.canvas_back_id);

		context_front = canvas_front[0].getContext("2d");
		context_back = canvas_back[0].getContext("2d");

		front_width = canvas_front.attr("width");
		front_height = canvas_front.attr("height");

		back_width = canvas_back.attr("width");
		back_height = canvas_back.attr("height");


		context_front.clearRect(0, 0, front_width, front_height);
		context_back.clearRect(0,0,back_width,back_height);
	}


	this.recompute_pos = function() {

		var canvas_front = $("#"+oThis.canvas_front_id);
		var canvas_back  = $("#"+oThis.canvas_back_id);

		//ctx_front = canvas_front[0].getContext("2d");
		//ctx_back  = canvas_back[0].getContext("2d")l

		order_item_id    = canvas_front.attr("data-order-item-id");
		quantity_counter = canvas_front.attr("data-repeated-counter");


		var new_canvas_front_width  = parseFloat(canvas_front.attr("width"));
		var new_canvas_front_height = parseFloat(canvas_front.attr("height"));

		console.log(new_canvas_front_width);
		console.log(new_canvas_front_height);

		if(order_item_id in window.pins) {
			if(quantity_counter in window.pins[order_item_id]) {

				var pins_front = Array();
				$.each(window.pins[order_item_id][repeated_counter]["front"],function(i,e) {
					scalex = new_canvas_front_width/parseFloat(e.canvas_width);
					scaley = new_canvas_front_height/parseFloat(e.canvas_height);

					e.x *= scalex;
					e.y *= scaley;
					e.canvas_width = new_canvas_front_width;
					e.canvas_height = new_canvas_front_height;
					pins_front.push(e);
				});
				window.pins[order_item_id][repeated_counter]["front"] = pins_front;


				var pins_back = Array();
				$.each(window.pins[order_item_id][repeated_counter]["back"],function(i,e) {
					scalex = new_canvas_front_width/parseFloat(e.canvas_width);
					scaley = new_canvas_front_height/parseFloat(e.canvas_height);

					e.x *= scalex;
					e.y *= scaley;
					e.canvas_width = new_canvas_front_width;
					e.canvas_height = new_canvas_front_height;
					pins_back.push(e);
				});

				window.pins[order_item_id][repeated_counter]["back"] = pins_back;
			};
		}
	}

	/***
	resizes the canvases according to image width to height ratio
	if window innner width is less than 767, then the canvases have width of 100%.
	*/
	this.resize_canvas = function() {
		//console.log("resize canvas");
		var widthToHeight = oThis.widthToHeight;
		var newWidth = window.innerWidth;
		var newHeight = window.innerHeight;
		var newWidthToHeight = newWidth / newHeight;

		var old_canvas_front_width  = parseFloat($("#"+oThis.canvas_front_id).attr("width"));
		var old_canvas_front_height = parseFloat($("#"+oThis.canvas_front_id).attr("height"));

		container_width = parseFloat(oThis.canvas_container.css("width"));


		//var ctx = $("#"+this.canvas_front_id)[0].getContext("2d");
		//var img_data = ctx.getImageData(0,0,old_canvas_front_width-1,old_canvas_front_height-1);
		if(newWidth>=700 && newWidth<=800) {
			newHeight = (newWidth/1.5) / widthToHeight;
			$("#"+oThis.canvas_front_id).attr("width",(newWidth/1.5));
			$("#"+oThis.canvas_front_id).attr("height",newHeight);

			$("#"+oThis.canvas_back_id).attr("width",(newWidth/1.5));
			$("#"+oThis.canvas_back_id).attr("height",newHeight);
		}
		if(newWidth<700) {

			newHeight = newWidth / widthToHeight;
			$("#"+oThis.canvas_front_id).attr("width",container_width);
			$("#"+oThis.canvas_front_id).attr("height",newHeight);

			$("#"+oThis.canvas_back_id).attr("width",container_width);
			$("#"+oThis.canvas_back_id).attr("height",newHeight);

		
		} else {
			var divider = 2;
			newHeight = (container_width/divider) / widthToHeight;
			
			$("#"+oThis.canvas_front_id).attr("width",container_width/divider);
			$("#"+oThis.canvas_front_id).attr("height",newHeight);

			$("#"+oThis.canvas_back_id).attr("width",container_width/divider);
			$("#"+oThis.canvas_back_id).attr("height",newHeight);
		}
		var new_canvas_front_width = parseFloat($("#"+oThis.canvas_front_id).attr("width"));
		var new_canvas_front_height = parseFloat($("#"+oThis.canvas_front_id).attr("height"));

		

		oThis.recompute_pos();
		oThis.redraw();
		

		oThis.draw_images();
	};

	/**
	this function will redraw all pins for the specified canvas by recomputing their positions on the canvas
	for both front canvas and back canvas
	*/
	this.redraw = function() {
		var canvas_front = $("#" + oThis.canvas_front_id);
		var canvas_back =  $("#" + oThis.canvas_back_id);

		var ctx_f = canvas_front[0].getContext("2d");
		var ctx_b = canvas_back[0].getContext("2d");

		order_item_id    = canvas_front.attr("data-order-item-id");
		repeated_counter = canvas_front.attr("data-repeated-counter");
		
		if(order_item_id in window.pins) {

			if(repeated_counter in window.pins[order_item_id]) {
				
				$.each(window.pins[order_item_id][repeated_counter]["front"],function(i,e) {
					ctx_f.fillStyle = "#FD0000";
		    		ctx_f.beginPath();
		   
		    		ctx_f.arc(e.x,e.y, oThis.radius, 0, 2*Math.PI);
		    		ctx_f.fill();
				});

				$.each(window.pins[order_item_id][repeated_counter]["back"],function(i,e) {
					ctx_b.fillStyle = "#FD0000";
		    		ctx_b.beginPath();
		   
		    		ctx_b.arc(e.x,e.y, oThis.radius, 0, 2*Math.PI);
		    		ctx_b.fill();
				});
				
		}
	}
		
	};


	this.inside_existing_pin = function(posx,posy,canvas) {
		var inside_pin = false;
		var order_item_id = $(canvas).attr("data-order-item-id");
		var repeated_counter = $(canvas).attr("data-repeated-counter");
		var type_canvas = $(canvas).attr("data-type-canvas");
		console.log("inside existing pin function");
		console.log("ordeer item id " + order_item_id);
		console.log("repeated counter" + repeated_counter);
		console.log("type canvas " + type_canvas);
		console.log(window.pins);
		if(order_item_id in window.pins) {
			if(repeated_counter in window.pins[order_item_id]) {
				console.log(window.pins[order_item_id][repeated_counter][type_canvas]);
				$.each(window.pins[order_item_id][repeated_counter][type_canvas],function(i,e) {
					//console.log(i);
					if(Math.sqrt((posx-e.x)*(posx-e.x) + (posy-e.y)*(posy-e.y)) < e.rad) {
						console.log("clicked inside circle");
						window.options_ctrl.set_pin_info(order_item_id,repeated_counter,type_canvas,i);
						inside_pin = true;
						return false;
					}
				});
			}
		}
		return inside_pin;
	};


	this.draw = function(e,canvas) {
		var radius = oThis.radius;
	    var pos = oThis.get_mouse_pos(canvas, e);

	    posx = pos.x;
	    posy = pos.y;
	    console.log("pos x: " + posx+ ", pos y: "+posy);
	    context = $(canvas)[0].getContext("2d");

	    var order_item_id = $(canvas).attr("data-order-item-id");
	    var repeated_counter = $(canvas).attr("data-repeated-counter");
	    var canvas_type = $(canvas).attr("data-type-canvas");

	    

	    if(oThis.inside_existing_pin(posx,posy,canvas)) {
	    	console.log("clicked inside pin");
	    	groups_to_show = window.squares_ctrl.inside_squares(posx,posy,order_item_id,canvas_type);
			window.options_ctrl.box_options_existing_circle(groups_to_show);

	    } else {
	    	console.log("maybe new pin");
	    	
			order_item_id = $(canvas).attr("data-order-item-id");
			repeated_counter = $(canvas).attr("data-repeated-counter");


			groups_to_show = window.squares_ctrl.inside_squares(posx,posy,order_item_id,canvas_type);
			
			// add object related to order if there is none
			if(!(order_item_id in window.pins)) {
				window.pins[order_item_id] = {};
			}
			if(!(repeated_counter in window.pins[order_item_id])) {
				window.pins[order_item_id][repeated_counter] = {front:Array(), back:Array()};
			}

		    window.pins[order_item_id][repeated_counter][canvas_type].push({x: posx,y:posy,rad: radius,canvas_width: parseFloat($(canvas).attr("width")),canvas_height: parseFloat($(canvas).attr("height")) });

		    var arr_length = window.pins[order_item_id][repeated_counter][canvas_type].length-1;

		    window.options_ctrl.set_pin_info(order_item_id,repeated_counter,canvas_type,arr_length);

		    options_available = window.options_ctrl.move_options_box(canvas,e,groups_to_show);
		    console.log(window.options_ctrl.options);
		    if(options_available) {
		    	console.log("options available");
		    	context.fillStyle = "#FD0000";
		    	context.beginPath();
		    	context.arc(posx, posy, radius, 0, 2*Math.PI);
		    	context.fill();
			} else {
				window.pins[order_item_id][repeated_counter][canvas_type].pop();
			}
		    console.log(window.pins);
		}
	};


	this.get_mouse_pos = function(canvas, evt) {
	    var rect = canvas.getBoundingClientRect();
	    return {
	      x: evt.clientX - rect.left,
	      y: evt.clientY - rect.top
	    };
	};



	this.validate_pins = function() {

		var canvas_front = $("#test-canvas-front");
		var canvas_back = $("#test-canvas-back");
		order_item_id = canvas_front.attr("data-order-item-id");
		quantity_counter = canvas_front.attr("data-repeated-counter");

		var errors = Array();
		if(window.pins !=="undefined") {
			if(order_item_id in window.pins) {
				if(quantity_counter in window.pins[order_item_id]) {
					if(window.pins[order_item_id][quantity_counter]["front"].length==0 
						&& window.pins[order_item_id][quantity_counter]["back"].length==0) {
						errors.push("you must add at least one pin on either image");
					} else {
						$.each(window.pins[order_item_id][quantity_counter]["front"],function(idx,obj) {
							if(!("attribute" in obj) || !("group" in obj)) {
								errors.push("you must select an answer for each pin in front image");
								return false;
							}
						});

						$.each(window.pins[order_item_id][quantity_counter]["back"],function(idx,obj) {
							if(!("attribute" in obj) || !("group" in obj)) {
								errors.push("you must select an answer for each pin in back image");
								return false;
							}
						});
					}
				} else {errors.push("you must add at least one pin in either image");}
			} else {errors.push("you must add at least one pin in either image");}
		} else {errors.push("there was an error with saving your information. contact customer service");}
		return errors;
	}

	this.init = function() {

		$("#"+oThis.canvas_front_id+",#"+oThis.canvas_back_id).on("click",function(event) {
			//console.log("canvas clicked");
			oThis.draw(event,this);
		});
	};
};