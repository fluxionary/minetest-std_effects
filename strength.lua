local S = std_effects.S

std_effects.strength = status_effects.register_effect("strength", {
	description = S("strength"),
	fold = function(self, values_by_key)
		return std_effects.util.sum_values(values_by_key)
	end,
	step_every = 1,
	step_catchup = false,
	on_step = function(self, player, value, dtime)
		local wielded_item = player:get_wielded_item()
		if value <= 0 then
			toolcap_monoids.full_punch:del_change(wielded_item, "std_effects:strength")
			toolcap_monoids.dig_speed:del_change(wielded_item, "std_effects:strength")
			toolcap_monoids.damage:del_change(wielded_item, "std_effects:strength")
		else
			toolcap_monoids.full_punch:add_change(
				wielded_item,
				math.pow(1 / (value + 1), 1 / 3),
				"std_effects:strength"
			)
			toolcap_monoids.dig_speed:add_change(wielded_item, math.pow(1 / (value + 1), 1 / 3), "std_effects:strength")
			toolcap_monoids.damage:add_change(wielded_item, { fleshy = value }, "std_effects:strength")
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
	hud_line = std_effects.util.numeric_hud_line,
})
