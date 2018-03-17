require "main.modules.unit_data"

ingame_state = {
	gui_selected_unit = nil,
	placed_units = {},
	owned_units = {},
}

function place_unit(unit_id, previous_tile_id)
	if not ingame_state.placed_units[unit_id] then
		ingame_state.placed_units[unit_id] = 0
	end

	local available_units = ingame_state.owned_units[unit_id] - ingame_state.placed_units[unit_id]

	if available_units > 0 then
		local prev_unit_id = get_unit_id_from_tile_index(previous_tile_id)
		if prev_unit_id then
			ingame_state.placed_units[prev_unit_id] = ingame_state.placed_units[prev_unit_id] - 1
		end
		ingame_state.placed_units[unit_id] = ingame_state.placed_units[unit_id] + 1
		return true
	else
		return false
	end
end
