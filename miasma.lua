--[[
	function(player)
		player:set_breath(player:get_breath()-4)
		if player:get_breath() < 4 then
			player:set_breath(1)
		end
	end,
]]

local breath_attribute = player_attributes.get_bounded_attribute("breath")

std_effects.miasma = status_effects.register_effect("miasma", {
	fold = function(self, values_by_key)
		return std_effects.util.sum_values(values_by_key)
	end,
	apply = function(self, player, value, old_value)
		if value <= 0 and old_value > 0 then
			breath_attribute:clear_max(player, "std_effects:miasma")
		elseif old_value <= 0 and value > 0 then
			breath_attribute:add_max_ephemeral(player, "std_effects:miasma", -2 * value)
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
	hud_line = std_effects.util.numeric_hud_line,
})
