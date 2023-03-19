std_effects.stunned = status_effects.register_effect("stunned", {
	fold = function(self, t)
		return #t > 0 and futil.functional.all(t)
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
