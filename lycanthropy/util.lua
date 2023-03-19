-- between 19:30 and 04:30
local function is_night()
	local timeofday = minetest.get_timeofday()
	return timeofday < (4.5 / 24) or timeofday > (19.5 / 24)
end

std_effects.util.werewolf_ok = function(player)
	return is_night() and futil.can_see_sky(player:get_pos(), 40)
end
