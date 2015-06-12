var OptionsCtrl = function() {
		var oThis = this;
		this.options = {};
		this.options_original = {};
		this.options_elem = null;
		this.groups_selected = {};

		this.order_item_id = null;
		this.repeated_item = null;
		this.canvas_type   = null;
		this.array_pos     = null;
		
		this.set_pin_info = function(order_item_id,repeated_item, canvas_type, array_pos) {
			oThis.order_item_id = order_item_id;
			oThis.repeated_item = repeated_item;
			oThis.canvas_type   = canvas_type;
			oThis.array_pos     = array_pos;

			if(!(oThis.order_item_id in oThis.groups_selected)) {
				oThis.groups_selected[oThis.order_item_id] = {};
			}
			if(!(oThis.repeated_item in oThis.groups_selected[oThis.order_item_id])) {
				oThis.groups_selected[oThis.order_item_id][oThis.repeated_item] = Array();
			}
		};




		this.build_selections = function() {
			oThis.options_elem.empty();
			console.log(oThis.groups_selected);
			$.each(oThis.options,function(i,e) {
				console.log(i);

				if($.inArray(parseInt(i),oThis.groups_selected[oThis.order_item_id][oThis.repeated_item])<=-1) {

					$.each(e,function(idx,se) {
						console.log(i);
						console.log(oThis.groups_selected);
						
							var li = $("<li data-group='"+i+"' data-attribute-id='"+idx+"' />").html(se);
							oThis.options_elem.append(li);
						
					});
				}
			});
		};
		this.build_list = function(groups_to_show) {
			options_available = false;
			oThis.options_elem.empty();
		    	$.each(oThis.options,function(i,e) {
		    		if($.inArray(parseInt(i),oThis.groups_selected[oThis.order_item_id][oThis.repeated_item])<=-1 
		    			&& $.inArray(parseInt(i), groups_to_show)>=0) {
		    			options_available=true;
			    		$.each(e["children"],function(idx,se) {

			    			oThis.options_elem.append($("<li />").append($("<a href=\"#0\" class=\"cd-popup-close\" data-group-id=\""+i+"\" data-attribute-id=\""+idx+"\"/>").html(se)));
			    		});
			    	}
		    	});

		    	return options_available;
		}
		/**
		make popup appear
		build list with the items of attributes that can be displayed from groups that have not already been chosen
		*/
		this.move_options_box = function(canvas,evt,groups_to_show) {
		

			var options_available = false;
			if(window.pins!=="undefined") {
				options_available = oThis.build_list(groups_to_show);

		    	if(options_available) {
		    		oThis.options_elem.append($("<li />").append($("<a href=\"#0\" class=\"cd-popup-close clear-choice\" data-group-id=\"0\" data-attribute-id=\"0\" />").html("clear")));
		    		oThis.options_elem.closest(".cd-popup").addClass("is-visible");
		    	}
	    	}
	    	return options_available;
		};

		this.box_options_existing_circle = function(groups_to_show) {
			pin = window.pins[oThis.order_item_id][oThis.repeated_item][oThis.canvas_type][oThis.array_pos];
			
			oThis.options_elem.empty();
			group_id = 0;
			attribute_id = 0;
			if("group" in pin) {group_id = pin.group;}
			if("attribute" in pin) {attribute_id = pin.attribute;}

			console.log("existing circle to show");
			oThis.build_list(groups_to_show);
			if(group_id!=0 && group_id!=0) {

				$.each(oThis.options[group_id]["children"],function(i,e) {
					selected_str = "";
					if(i==attribute_id) {
						selected_str = "style=\"background:black;color:white\"";
					}
					oThis.options_elem.append($("<li />").
						append($("<a href=\"#0\" class=\"cd-popup-close\" data-group-id=\""+group_id
							+"\" data-attribute-id=\""+i+"\" "+selected_str+" />").html(e)));
				});

				//oThis.options_elem.append($("<li />").append($("<a href=\"#0\" class=\"cd-popup-close\" data-group-id=\""+group_id+"\" data-attribute-id=\""+attribute_id+"\" />").html(oThis.options[group_id]["children"][attribute_id])));
			}
			oThis.options_elem.append($("<li />").append($("<a href=\"#0\" class=\"cd-popup-close clear-choice\" data-group-id=\""+group_id+"\" data-attribute-id=\""+attribute_id+"\" />").html("clear")));
			oThis.options_elem.closest(".cd-popup").addClass("is-visible");

		};


		this.init = function() {

			oThis.options_elem.on("click","li a",function() {
				//console.log("clicked in a element");
				if(typeof window.pins === "undefined") {
					alert("cannot continue due to error");
					return;
				}
				
				if($(this).hasClass("clear-choice")) {
					this.group_to_remove = 0;
					
					this.pins = window.pins[oThis.order_item_id][oThis.repeated_item][oThis.canvas_type];
		
					if(this.pins.length==1) {
						window.pins[oThis.order_item_id][oThis.repeated_item][oThis.canvas_type] = Array();
					} else {
					
					this.pins = this.pins.splice(oThis.array_pos,1);
					
					}
					console.log(window.pins);
					

					new_groups_selected = Array();
			
					group_id = $(this).data("group-id");
					$.each(oThis.groups_selected[oThis.order_item_id][oThis.repeated_item],function(i,e) {
						if(e!=group_id) {
							new_groups_selected.push(e);
						}
					});
					//console.log(new_groups_selected);
					oThis.groups_selected[oThis.order_item_id][oThis.repeated_item] = new_groups_selected;
					//console.log(oThis.groups_selected[oThis.order_item_id][oThis.repeated_item]);
					if(window.canvas_ctrl!=="undefined") {
						window.canvas_ctrl.clear_canvas();
						window.canvas_ctrl.redraw();
						window.squares_ctrl.draw_areas(oThis.order_item_id);
					}
					//window.pins[oThis.order_item_id][oThis.repeated_item][oThis.canvas_type] = pins;
				} else {
					group_id = 0;
					// this means point has an attribute set to it (it is an existing pin)
					if("group" in window.pins[oThis.order_item_id][oThis.repeated_item][oThis.canvas_type][oThis.array_pos]) {
						group_id = parseInt(window.pins[oThis.order_item_id][oThis.repeated_item][oThis.canvas_type][oThis.array_pos]["group"]);
					}

					window.pins[oThis.order_item_id][oThis.repeated_item][oThis.canvas_type][oThis.array_pos]["group"] = $(this).data("group-id");
					window.pins[oThis.order_item_id][oThis.repeated_item][oThis.canvas_type][oThis.array_pos]["attribute"] = $(this).data("attribute-id");

					if(group_id>0) {
						new_groups_selected = Array();
						new_groups_selected.push($(this).data("group-id"));
						$.each(oThis.groups_selected[oThis.order_item_id][oThis.repeated_item],function(i,e) {
							if(e!=group_id) {
								new_groups_selected.push(e);
							}
						});

						oThis.groups_selected[oThis.order_item_id][oThis.repeated_item] = new_groups_selected;
					} else {
						oThis.groups_selected[oThis.order_item_id][oThis.repeated_item].push($(this).data("group-id"));
					}
					
				}

				
			});
		};
};