slowness_effect = fmod.create()
local S = slowness_effect.S

slowness_effect.effect = status_effects.register_effect("slowness", {
	description = S("slowness"),
	fold = function(self, t)
		return status_effects.fold.max(t, 1)
	end,
	apply = function(self, player, value, old_value)
		if value ~= old_value then
			if value <= 1 then
				player_monoids.speed:del_change(player, "slowness_effect")
			else
				player_monoids.speed:add_change(player, 1 / value, "slowness_effect")
			end
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
	hud_line = status_effects.hud_line.make_numeric(1),
})
