BOARD_MOUSE_HOVER_ID = "board_tilemap"

require "main.modules.ingame_state"
require "main.modules.unit_data"
require "main.modules.tilemap"
require "main.modules.mouse_cursor"

DEFAULT_TILE_INDEX = 1
PLACEMENT_TILE_INDEX = 2
MOVEMENT_OPTION_TILE_INDEX = 3
DIRECT_MOVEMENT_OPTION_TILE_INDEX = 4
SELECTED_TILE_INDEX = 9
TILE_SIZE = 40
TILEMAP_URL = "/board#board"
EFFECTS_LAYER = "effects"
BOARD_LAYER = "board"

function reset_effects()
	local _, _, width, height = tilemap.get_bounds(TILEMAP_URL)
	for i = 1, width do
		for j = 1, height do
			tilemap.set_tile(TILEMAP_URL, EFFECTS_LAYER, i, j, 0)
		end
	end
end

function table_contains_tile(table, element, key_to_lookup)
	for _, v in pairs(table) do
		if key_to_lookup then v = v[key_to_lookup] end
		if v.x == element.x and v.y == element.y then return true end
	end
	return false
end

function clear_selected_tile(self)
	if self.selected_tile then
		tilemap.set_tile(TILEMAP_URL, EFFECTS_LAYER, self.selected_tile.x, self.selected_tile.y, 0)
		self.selected_tile = nil
	end
end

function select_tile(self, tile)
	clear_selected_tile(self)
	tilemap.set_tile(TILEMAP_URL, EFFECTS_LAYER, tile.x, tile.y, SELECTED_TILE_INDEX)
	self.selected_tile = tile
end
