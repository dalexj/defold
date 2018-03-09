local function general_init(self)
	self.buttons = {}
	self.buttons_metadata = {}
	-- button states: NORMAL HOVER PRESSED
	self.cursor_is_hand = false
	self.mouse_down = false
end

local hover_color = vmath.vector4(0.7, 0.7, 0.7, 1)
local pressed_color = vmath.vector4(0.3, 0.3, 0.3, 1)

function buttons_init(self, ids)
	general_init(self)
	for _, button_id in pairs(ids) do
		self.buttons[button_id] = gui.get_node(button_id .. "/button")
		self.buttons_metadata[button_id] = {state = "NORMAL", default_color = gui.get_color(self.buttons[button_id])}
	end
end

function buttons_init_clone(self, proto_id, number_of_buttons, position_fn, text_fn)
	general_init(self)
	local button_proto = gui.get_node(proto_id .. "/button")
	for i = 1, number_of_buttons, 1 do
		local new_nodes = gui.clone_tree(button_proto)
		gui.set_position(new_nodes[hash(proto_id .. "/button")], position_fn(i))
		gui.set_text(new_nodes[hash(proto_id .."/text")], text_fn(i))
		self.buttons[i] = new_nodes[hash(proto_id .. "/button")]
		self.buttons_metadata[i] = {state = "NORMAL", default_color = gui.get_color(self.buttons[i])}
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
	for key, val in pairs(self.buttons) do
		local new_state = "NORMAL"
		if gui.pick_node(val, action.x, action.y) then
			-- mouse is inside this button
			hovering = true
			new_state = self.mouse_down and "PRESSED" or "HOVER"
			if action_id == hash("LEFT_CLICK") then
				if action.released == true then
					click_fn(key)
				end
			end
		end

		if new_state ~= self.buttons_metadata[key].state then
			self.buttons_metadata[key].state = new_state
			local new_color = ({
				NORMAL = self.buttons_metadata[key].default_color,
				HOVER = hover_color,
				PRESSED = pressed_color,
			})[new_state]
			gui.set_color(val, new_color)
		end
	end

	if hovering ~= self.cursor_is_hand then
		defos.set_cursor(hovering and defos.CURSOR_HAND or nil)
		self.cursor_is_hand = hovering
	end
end