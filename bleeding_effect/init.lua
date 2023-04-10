bleeding_effect = fmod.create()

local S = bleeding_effect.S

bleeding_effect.effect = status_effects.register_effect("bleeding", {
	description = S("bleeding"),
	fold = function(self, values_by_key)
		return status_effects.fold.sum(values_by_key, 0)
	end,
	step_every = 1,
	step_catchup = true,
	on_step = function(self, player, value, dtime)
		if value == 0 then
			return
		end
		local hp = player:get_hp()
		player:set_hp(hp - value, { type = "set_hp", cause = "std_effects:bleeding" })
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
	hud_line = status_effects.hud_line.numeric,
})
