var SquaresCtrl = function() {
	var oThis = this;
	this.squares = {};

	this.inside_squares = function(x,y,prod_id,canvas_type) {
		groups = Array();
		if(prod_id in oThis.squares) {
				if(canvas_type in oThis.squares[prod_id]) {
				$.each(oThis.squares[prod_id][canvas_type],function(i,e) {
				

					if(x>=parseFloat(e['x']) && y>=parseFloat(e['y']) 
						&& x<=(parseFloat(e['x'])+parseFloat(e['width'])) 
						&& y<=(parseFloat(e['y']) + parseFloat(e['height'])) ) {
						groups.push(e['group']);
					}
				});
			}
		}
		console.log("square groups");
		console.log(groups);
		return groups;
	}
	/**
	this will recompute the position of the rectangle to respond to new canvas size
	**/
	this.recompute_pos = function() {
		var canvas_front = $("#"+window.canvas_ctrl.canvas_front_id);
		var canvas_back  = $("#"+window.canvas_ctrl.canvas_back_id);

		order_item_id    = canvas_front.attr("data-order-item-id");
		quantity_counter = canvas_front.attr("data-repeated-counter");


		var new_canvas_front_width  = parseFloat(canvas_front.attr("width"));
		var new_canvas_front_height = parseFloat(canvas_front.attr("height"));
		console.log(new_canvas_front_width);
		$.each(oThis.squares,function(i,e) {
			$.each(e,function(idx,se) {
				var squares_front = Array();
				var squares_back  = Array();

				$.each(e["front"],function(indx, obj) {
					scalex = new_canvas_front_width/parseFloat(obj.cw);
					scaley = new_canvas_front_height/parseFloat(obj.ch);

					obj.x      *= scalex;
					obj.y      *= scaley;
					obj.width  *= scalex;
					obj.height *= scaley;
					obj.cw     = new_canvas_front_width;
					obj.ch     = new_canvas_front_height;
					squares_front.push(obj);
				});

				$.each(e["back"],function(indx, obj) {
					scalex = new_canvas_front_width/parseFloat(obj.cw);
					scaley = new_canvas_front_height/parseFloat(obj.ch);

					obj.x      *= scalex;
					obj.y      *= scaley;
					obj.width  *= scalex;
					obj.height *= scaley;
					obj.cw     = new_canvas_front_width;
					obj.ch     = new_canvas_front_height;
					squares_back.push(obj);
				});

				oThis.squares[i][idx]['front'] = squares_front;
				oThis.squares[i][idx]['back']  = squares_back;
			});
		});
	}

	this.draw_areas = function() {
		var canvas_front = $("#"+window.canvas_ctrl.canvas_front_id);
		var canvas_back  = $("#"+window.canvas_ctrl.canvas_back_id);

		ctx_f = canvas_front[0].getContext("2d");
		ctx_b = canvas_back[0].getContext("2d");

		var prod_id = canvas_front.attr("data-order-item-id");

		if(prod_id in oThis.squares) {
			$.each(oThis.squares[prod_id]["front"],function(i,e) {
				ctx_f.rect(e.x,e.y,e.width,e.height);
				ctx_f.stroke(); 
			});
		}
	};
};