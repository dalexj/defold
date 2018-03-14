function get_tile_within_coords(tilemap_url, tile_size, action)
	-- assumes tilemap is within positive coordinates, starting at {1,1}
	local pos = go.get_position(tilemap_url)
	local _, _, x_tiles, y_tiles = tilemap.get_bounds(tilemap_url)
	local x_lower = pos.x
	local y_lower = pos.y
	local x_upper = x_lower + ( x_tiles * tile_size)
	local y_upper = y_lower + ( y_tiles * tile_size)
	if x_lower <= action.x and x_upper >= action.x and y_lower <= action.y and y_upper >= action.y then
		return {
			x = math.ceil((action.x - x_lower) / tile_size),
			y = math.ceil((action.y - y_lower) / tile_size),
		}
	else
		return false
	end
end