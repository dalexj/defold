local function general_init(self)
	if not self.buttons then self.buttons = {} end
	if not self.buttons_metadata then self.buttons_metadata = {} end
	-- button states: NORMAL HOVER PRESSED
	self.cursor_is_hand = false
	self.mouse_down = false
end

function buttons_init(self, ids)
	general_init(self)
	for _, button_id in pairs(ids) do
		self.buttons[button_id] = {
			bg = gui.get_node(button_id .. "/bg"),
			skip_effects = false,
			state = "NORMAL"
		}
		self.buttons[button_id].default_color = gui.get_color(self.buttons[button_id].bg)
	end
	self.hover_color = vmath.vector4(0.7, 0.7, 0.7, 1)
	self.pressed_color = vmath.vector4(0.3, 0.3, 0.3, 1)
end

function buttons_init_clone(self, proto_id, number_of_buttons, position_fn, text_fn)
	general_init(self)
	local button_proto = gui.get_node(proto_id .. "/bg")
	local default_color = gui.get_color(button_proto)
	for i = 1, number_of_buttons, 1 do
		local new_nodes = gui.clone_tree(button_proto)
		self.buttons[i] = {
			bg = new_nodes[hash(proto_id .. "/bg")],
			text = new_nodes[hash(proto_id .."/text")],
			skip_effects = false,
			state = "NORMAL",
			default_color = default_color,
		}
		gui.set_position(self.buttons[i].bg, position_fn(i))
		gui.set_text(self.buttons[i].text, text_fn(i))
	end
	gui.set_enabled(button_proto, false)
end

function buttons_on_input(self, action_id, action, click_fn)
	
	if action_id == hash("LEFT_CLICK") and action.released then
		self.mouse_down = false
	end
	if action_id == hash("LEFT_CLICK") and action.pressed then
		self.mouse_down = true
	end

	local hovering = false
	for key, button in pairs(self.buttons) do
		local new_state = "NORMAL"
		if gui.is_enabled(button.bg) and gui.pick_node(button.bg, action.x, action.y) then
			-- mouse is inside this button
			hovering = true
			
			new_state = self.mouse_down and "PRESSED" or "HOVER"
			if action_id == hash("LEFT_CLICK") then
				if action.released == true then
					click_fn(key)
				end
			end
		end

		if not button.skip_effects and new_state ~= button.state then
			button.state = new_state
			local new_color = ({
				NORMAL = self.buttons[key].default_color,
				HOVER = self.hover_color,
				PRESSED = self.pressed_color,
			})[new_state]
			gui.set_color(button.bg, new_color)
		end
	end

	if hovering ~= self.cursor_is_hand then
		defos.set_cursor(hovering and defos.CURSOR_HAND or nil)
		self.cursor_is_hand = hovering
	end
end