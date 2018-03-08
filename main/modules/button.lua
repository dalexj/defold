local function general_init(self)
	self.buttons = {}
	self.mouse_hovering_on_buttons = false
	self.current_hovering_button = nil
	self.previous_button_color = nil
end

function buttons_init(self, ids)
	general_init(self)
	for _, button_id in pairs(ids) do
		self.buttons[button_id] = gui.get_node(button_id .. "/button")
	end
end

function buttons_init_clone(self, proto_id, number_of_buttons, position_fn, text_fn)
	general_init(self)
	local button_proto = gui.get_node(proto_id .. "/button")
	for i = 1, number_of_buttons, 1 do
		local new_nodes = gui.clone_tree(button_proto)
		gui.set_position(new_nodes[hash(proto_id .. "/button")], position_fn(i))
		gui.set_text(new_nodes[hash(proto_id .."/text")], text_fn(i))
		table.insert(self.buttons, new_nodes[hash(proto_id .. "/button")])
	end
end

function buttons_on_input(self, action_id, action, click_fn)
	local is_mouse_inside = false
	local button_inside_mouse = nil
	for key, val in pairs(self.buttons) do
		if(gui.pick_node(val, action.x, action.y)) then
			is_mouse_inside = true
			button_inside_mouse = key
			break
		end
	end

	if(action_id == hash("LEFT_CLICK") and action.released == true) then
		if is_mouse_inside then
			click_fn(button_inside_mouse)
		end
	end

	if action_id == nil then
		if is_mouse_inside then
			if not self.mouse_hovering_on_buttons then
				self.mouse_hovering_on_buttons = true
				self.current_hovering_button = button_inside_mouse
				self.previous_button_color = gui.get_color(self.buttons[self.current_hovering_button])
				gui.set_color(self.buttons[self.current_hovering_button], vmath.vector4(0.7, 0.7, 0.7, 1))
				defos.set_cursor(defos.CURSOR_HAND)
			end
		else
			if self.mouse_hovering_on_buttons then
				self.mouse_hovering_on_buttons = false
				gui.set_color(self.buttons[self.current_hovering_button], self.previous_button_color)
				self.current_hovering_button = nil
				self.previous_button_color = nil
				defos.reset_cursor()
			end
		end
	end
end