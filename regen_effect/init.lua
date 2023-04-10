regen_effect = fmod.create()
local s = regen_effect.settings
local S = regen_effect.S

regen_effect.effect = status_effects.register_effect("regen", {
	description = S("regen"),
	fold = function(self, t)
		return status_effects.fold.sum(t, s.base_value)
	end,
	step_every = 1,
	step_catchup = false, -- we use dtime to scale the effect
	on_step = function(self, player, value, dtime)
		if value == 0 then
			return
		end
		local hp = player:get_hp()
		value = value * dtime * s.rate
		local int_value = math.floor(value)
		local float_part = value - int_value
		if math.random() <= float_part then
			int_value = int_value + 1
		end
		player:set_hp(hp + int_value, { type = "set_hp", cause = "regen_effect:regen" })
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
})
