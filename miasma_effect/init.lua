miasma_effect = fmod.create()
--[[
	function(player)
		player:set_breath(player:get_breath()-4)
		if player:get_breath() < 4 then
			player:set_breath(1)
		end
	end,
]]

local S = miasma_effect.S

local breath_attribute = player_attributes.get_bounded_attribute("breath")

miasma_effect.effect = status_effects.register_effect("miasma", {
	description = S("miasma"),
	fold = function(self, values_by_key)
		return status_effects.fold.sum(values_by_key)
	end,
	apply = function(self, player, value, old_value)
		if value <= 0 and old_value > 0 then
			breath_attribute:clear_max(player, "miasma_effect:miasma")
		elseif old_value <= 0 and value > 0 then
			breath_attribute:add_max_ephemeral(player, "miasma_effect:miasma", -2 * value)
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
	hud_line = status_effects.hud_line.numeric,
})
