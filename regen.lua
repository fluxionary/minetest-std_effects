local s = std_effects.settings
local S = std_effects.S

std_effects.regen = status_effects.register_effect("regen", {
	description = S("regen"),
	fold = function(self, t)
		return std_effects.util.sum_values(t, s.base_regen_value)
	end,
	step_every = 1,
	step_catchup = false, -- we use dtime to scale the effect
	on_step = function(self, player, value, dtime)
		if value == 0 then
			return
		end
		local hp = player:get_hp()
		value = value * dtime * s.regen_rate
		local int_value = math.floor(value)
		local float_part = value - int_value
		if math.random() <= float_part then
			int_value = int_value + 1
		end
		player:set_hp(hp + int_value, { type = "set_hp", cause = "std_effects:regen" })
	end,

	on_die = function(self, player)
		self:clear(player)
	end,
})
