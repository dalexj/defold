local function make_attack(name, damage, range, type)
	return {
		name = name,
		damage = damage,
		range = range,
		type = type,
	}
end

local function make_stats(name, max_hp, max_moves, cost, attacks)
	return {
		name = name,
		max_hp = max_hp,
		max_moves = max_moves,
		cost = cost,
		attacks = attacks,
	}
end

local unit_id_to_default_stats = {
	hack = make_stats("hack", 4, 2, 10, { make_attack("slice", 2, 1, "attack") }),
	battery = make_stats("battery", 1, 0, 10, { make_attack("zap", 2, 3, "attack") }),
	fence = make_stats("fence", 4, 1, 10, { make_attack("keep out", 2, 1, "attack") }),
	doc = make_stats("doc", 3, 3, 10, { make_attack("grow", 1, 1, "grow") }),
}
local unit_id_to_tile_index = {
	hack = 5,
	battery = 6,
	fence = 7,
	doc = 8,
}
local tile_index_to_unit_id_index = {}
for k,v in pairs(unit_id_to_tile_index) do
	tile_index_to_unit_id_index[v] = k
end

function get_tile_index_from_unit_id(unit_id)
	return unit_id_to_tile_index[unit_id]
end

function get_unit_id_from_tile_index(tile_index)
	return tile_index_to_unit_id_index[tile_index]
end

function get_unit_default_stats(unit_id)
	return unit_id_to_default_stats[unit_id]
end
