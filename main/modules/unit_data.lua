local function make_attack(name, damage, range, type)
	return {
		name = name,
		damage = damage,
		range = range,
		type = type,
	}
end

local function make_stats(name, max_hp, moves, cost, attacks)
	return {
		name = name,
		max_hp = max_hp,
		moves = moves,
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
	hack = 3,
	battery = 4,
	fence = 5,
	doc = 6,
}

function get_tile_index_from_unit_id(unit_id)
	return unit_id_to_tile_index[unit_id]
end

function get_unit_default_stats(unit_id)
	return unit_id_to_default_stats[unit_id]
end