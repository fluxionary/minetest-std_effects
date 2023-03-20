-- https://gitea.your-land.de/your-land/yl_statuseffects/commit/1aae2633c40a6880e8ea14f317f649c4e1a6baf2

std_effects.stunned = status_effects.register_effect("stunned", {
	fold = function(self, t)
		return not futil.table.is_empty(t) and futil.functional.iall(futil.iterators.values(t))
	end,
	apply = function(self, player, value, old_value)
		if value and not old_value then
			player_monoids.speed:add_change(player, 0, "std_effects:stunned")
			player_monoids.jump:add_change(player, 0, "std_effects:stunned")
		elseif old_value and not value then
			player_monoids.speed:del_change(player, "std_effects:stunned")
			player_monoids.jump:del_change(player, "std_effects:stunned")
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
})
