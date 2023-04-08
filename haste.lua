local S = std_effects.S

std_effects.haste = status_effects.register_effect("haste", {
	description = S("haste"),
	fold = function(self, t)
		return std_effects.util.max_values(t, 1)
	end,
	apply = function(self, player, value, old_value)
		if value ~= old_value then
			if value <= 1 then
				player_monoids.speed:del_change(player, "std_effects:haste")
			else
				player_monoids.speed:add_change(player, value, "std_effects:haste")
			end
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
	-- TODO: make something for multiplicative values
	--hud_line = std_effects.util.numeric_hud_line,
})
