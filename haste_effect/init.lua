haste_effect = fmod.create()

local S = haste_effect.S

haste_effect.effect = status_effects.register_effect("haste", {
	description = S("haste"),
	fold = function(self, t)
		return status_effects.fold.max(t, 1)
	end,
	apply = function(self, player, value, old_value)
		if value ~= old_value then
			if value <= 1 then
				player_monoids.speed:del_change(player, "haste_effect")
			else
				player_monoids.speed:add_change(player, value, "haste_effect")
			end
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
	hud_line = status_effects.hud_line.make_numeric(1),
})
