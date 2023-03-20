std_effects.regen = status_effects.register_effect("regen", {
	fold = function(self, t)
		return futil.math.isum(futil.iterators.values(t), 0)
	end,
	step_every = 1,
	step_catchup = true,
	on_step = function(self, player, value, dtime)
		if value == 0 then
			return
		end
		local hp = player:get_hp()
		player:set_hp(hp + value, { type = "set_hp", cause = "std_effects:regen" })
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
})
