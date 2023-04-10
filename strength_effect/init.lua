strength_effect = fmod.create()

local S = strength_effect.S
local has = strength_effect.has

strength_effect.effect = status_effects.register_effect("strength", {
	description = S("strength"),
	fold = function(self, values_by_key)
		return status_effects.fold.sum(values_by_key)
	end,
	step_every = 1,
	step_catchup = false,
	on_step = function(self, player, value, dtime)
		local wielded_item = player:get_wielded_item()
		if value <= 0 then
			if has.toolcap_monoids then
				toolcap_monoids.full_punch:del_change(wielded_item, "strength_effect:strength")
				toolcap_monoids.dig_speed:del_change(wielded_item, "strength_effect:strength")
				toolcap_monoids.damage:del_change(wielded_item, "strength_effect:strength")
			end
		else
			if has.toolcap_monoids then
				-- TODO constants to settings
				toolcap_monoids.full_punch:add_change(
					wielded_item,
					math.pow(1 / (value + 1), 1 / 3),
					"strength_effect:strength"
				)
				toolcap_monoids.dig_speed:add_change(
					wielded_item,
					math.pow(1 / (value + 1), 1 / 3),
					"strength_effect:strength"
				)
				toolcap_monoids.damage:add_change(wielded_item, { fleshy = value }, "strength_effect:strength")
			end
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
	hud_line = status_effects.hud_line.numeric,
})
