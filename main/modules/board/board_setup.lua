require "main.modules.board.board_common"

local board_setup = {}

function board_setup.init(self)
  self.placement_spots = {}
	local _, _, width, height = tilemap.get_bounds(TILEMAP_URL)
	for i = 1, width do
		for j = 1, height do
			if tilemap.get_tile(TILEMAP_URL, BOARD_LAYER, i, j) == PLACEMENT_TILE_INDEX then
				table.insert(self.placement_spots, { x = i, y = j })
			end
		end
	end
	self.can_start = false
	self.selected_tile = nil
end

function board_setup.on_input(self, action_id, action)
  local tile = get_tile_within_coords(TILEMAP_URL, TILE_SIZE, action)
  if not tile then return end
  local tile_id = tilemap.get_tile(TILEMAP_URL, BOARD_LAYER, tile.x, tile.y)

	if table_contains_tile(self.placement_spots, tile, nil) then
		mouse_hovering_id = "board_tilemap"
		if action_id == hash("LEFT_CLICK") and action.released then
			select_tile(self, tile)
			if ingame_state.gui_selected_unit then
				if not self.can_start then
					msg.post("/ingame_setup_gui", "enable_start_button")
					self.can_start = true
				end
				if place_unit(ingame_state.gui_selected_unit, tile_id) then
					msg.post("/ingame_setup_gui", "update")
					tilemap.set_tile(TILEMAP_URL, BOARD_LAYER, tile.x, tile.y, get_tile_index_from_unit_id(ingame_state.gui_selected_unit))
				end
			end
		end
	elseif mouse_hovering_id == "board_tilemap" then
		mouse_hovering_id = nil
	end
end

function board_setup.on_message(self, message_id, message, sender)
  if message_id == hash("start_game") and self.can_start then
    self.player_units = {}
    clear_selected_tile(self)
    for _, spot in pairs(self.placement_spots) do
      local tile_index = tilemap.get_tile(TILEMAP_URL, BOARD_LAYER, spot.x, spot.y)
      if tile_index == PLACEMENT_TILE_INDEX then
        tilemap.set_tile(TILEMAP_URL, BOARD_LAYER, spot.x, spot.y, DEFAULT_TILE_INDEX)
      else
        local unit_id = get_unit_id_from_tile_index(tile_index)
        local default_stats = get_unit_default_stats(unit_id)
        table.insert(self.player_units, {
          id = unit_id,
          tiles = {spot},
          head = spot,
          max_moves = default_stats.max_moves,
          max_hp = default_stats.max_hp,
          moves_made = 0,
          attack_mode = false,
          finished_turn = false,
          attacks = default_stats.attacks,
        })
      end

    end
    print("game started")
    self.phase = "playing"
  end
end

return board_setup
