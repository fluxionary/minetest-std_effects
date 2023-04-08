local S = std_effects.S

std_effects.slowness = status_effects.register_effect("slowness", {
	description = S("slowness"),
	fold = function(self, t)
		return std_effects.util.max_values(t, 1)
	end,
	apply = function(self, player, value, old_value)
		if value ~= old_value then
			if value <= 1 then
				player_monoids.speed:del_change(player, "std_effects:slowness")
			else
				player_monoids.speed:add_change(player, 1 / value, "std_effects:slowness")
			end
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
	-- TODO: make something for multiplicative values
	--hud_line = std_effects.util.numeric_hud_line,
})
