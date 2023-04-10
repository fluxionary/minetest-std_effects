local s = builders_flight_effect.settings

local key = "builders_flight_effect_last_modified_time"

areas:registerOnAdd(function(id, area)
	area[key] = os.time()
end)

areas:registerOnMove(function(id, area, pos1, pos2)
	area[key] = os.time()
end)

function builders_flight_effect.in_valid_area(player)
	local player_name = player:get_player_name()
	local pos = player:get_pos()
	local now = os.time()
	local pmin = vector.subtract(pos, s.area_check_radius)
	local pmax = vector.add(pos, s.area_check_radius)
	local areas_at_pos = areas:getAreasIntersectingArea(pmin, pmax)
	for id, area in pairs(areas_at_pos) do
		if area.owner == player_name and (now - (area[key] or 0) > s.min_valid_area_time) then
			return true
		end
	end
	return false
end
