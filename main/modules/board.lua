local board = {}

function board.reset_effects()
	local _, _, width, height = tilemap.get_bounds(TILEMAP_URL)
	for i = 1, width do
		for j = 1, height do
			tilemap.set_tile(TILEMAP_URL, EFFECTS_LAYER, i, j, 0)
		end
	end
end

return board
