var OptionsCtrl = function() {
		var oThis = this;
		this.options = {};
		this.options_elem = null;
		this.groups_selected = Array();

		this.order_item_id = null;
		this.repeated_item = null;
		this.canvas_type   = null;
		this.array_pos     = null;
		
		this.set_pin_info = function(order_item_id,repeated_item, canvas_type, array_pos) {
			oThis.order_item_id = order_item_id;
			oThis.repeated_item = repeated_item;
			oThis.canvas_type   = canvas_type;
			oThis.array_pos     = array_pos;
		}

		this.build_selections = function() {
			oThis.options_elem.empty();
			$.each(oThis.options,function(i,e) {
				if($.inArray(i,oThis.groups_selected)<=-1) {
					$.each(e,function(idx,se) {
						var li = $("<li data-group='"+i+"' data-attribute-id='"+idx+"' />").html(se);
						oThis.options_elem.append(li);
					});
				}
			});
		}

		/**
		moves options box to wherever the right of wherever the pin was created or an existing one was clicked
		*/
		this.move_options_box = function(canvas,evt) {
			if(oThis.options_elem==null) {
				return;
			}

			var canvas_left = 0;
			if($(canvas).data("type-canvas")=="front") {
				canvas_left = parseInt($(canvas).css("width"));
			}
	

			box_width = (parseInt(this.options_elem.css("width")) +20 );
	    	box_height = parseInt(this.options_elem.css("height"));

	    	//console.log(oThis.options_elem);
	    	oThis.build_selections();
	    	oThis.options_elem.css({"left":evt.clientX+20,"top":evt.clientY-box_height/2});
	    	oThis.options_elem.show();
	    	oThis.options_elem.addClass("options-visible");

		};


		this.init = function() {

			oThis.options_elem.on("click","li",function() {
				if(typeof window.pins === "undefined") {
					console.log("pins variable not found");
					return;
				}
				
				if($(this).hasClass("clear-choice")) {
					// do something to clear choice
				} else {

					window.pins[oThis.order_item_id][oThis.repeated_item][oThis.canvas_type][oThis.array_pos]["group"] = $(this).data("group");
					window.pins[oThis.order_item_id][oThis.repeated_item][oThis.canvas_type][oThis.array_pos]["attribute"] = $(this).data("attribute-id");
					oThis.groups_selected.push($(this).data("group"));
				}

				console.log(window.pins);

				oThis.options_elem.hide();
				oThis.options_elem.removeClass("options-visible");
			});
		}
	};