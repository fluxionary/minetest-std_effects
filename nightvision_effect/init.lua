nightvision_effect = fmod.create()

local S = nightvision_effect.S

nightvision_effect.effect = status_effects.register_effect("nightvision", {
	description = S("nightvision"),
	fold = function(self, values_by_key)
		return status_effects.fold.any(values_by_key)
	end,
	apply = function(self, player, value, old_value)
		if value and not old_value then
			more_player_monoids.day_night_ratio:add_change(player, tonumber("inf"), "nightvision_effect")
		elseif old_value and not value then
			more_player_monoids.day_night_ratio:del_change(player, "nightvision_effect")
		end
	end,
	hud_line = status_effects.hud_line.boolean,
})
