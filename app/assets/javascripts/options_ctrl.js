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
		}




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
		}

		/**
		make popup appear
		build list with the items of attributes that can be displayed from groups that have not already been chosen
		*/
		this.move_options_box = function(canvas,evt) {
			//console.log(Object.keys(oThis.options));
			//console.log()
			var options_available = false;
			if(window.pins!=="undefined") {
				oThis.options_elem.empty();
		    	$.each(oThis.options,function(i,e) {
		    		if($.inArray(parseInt(i),oThis.groups_selected[oThis.order_item_id][oThis.repeated_item])<=-1) {
		    			options_available=true;
			    		$.each(e["children"],function(idx,se) {
			    			oThis.options_elem.append($("<li />").append($("<a href=\"#0\" class=\"cd-popup-close\" data-group-id=\""+i+"\" data-attribute-id=\""+idx+"\"/>").html(se)));
			    		});
			    	}
		    	});

		    	if(options_available) {
		    		oThis.options_elem.closest(".cd-popup").addClass("is-visible");
		    	}
	    	}
	    	return options_available;
		};


		this.init = function() {

			oThis.options_elem.on("click","li a",function() {
				//console.log("clicked in a element");
				if(typeof window.pins === "undefined") {
					alert("cannot continue due to error");
					return;
				}
				
				if($(this).hasClass("clear-choice")) {
					// do something to clear choice
				} else {

					window.pins[oThis.order_item_id][oThis.repeated_item][oThis.canvas_type][oThis.array_pos]["group"] = $(this).data("group-id");
					window.pins[oThis.order_item_id][oThis.repeated_item][oThis.canvas_type][oThis.array_pos]["attribute"] = $(this).data("attribute-id");
					oThis.groups_selected[oThis.order_item_id][oThis.repeated_item].push($(this).data("group-id"));
					//delete oThis.options[$(this).data("group-id")];
				}

				//console.log(window.pins);
				//console.log(oThis.groups_selected);
				//console.log(oThis.options);
				//oThis.options_elem.hide();
				//oThis.options_elem.removeClass("options-visible");
			});
		}
	};