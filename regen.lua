std_effects.regen = status_effects.register_effect("regen", {
	fold = function(self, t)
		return futil.math.sum(t, 0)
	end,
	on_step = function(self, player, value)
		if value == 0 then
			return
		end
		if self:every(player, 1) then
			local hp = player:get_hp()
			player:set_hp(hp + value, { type = "set_hp", cause = "std_effects:regen" })
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
})
