local S = std_effects.S

local function is_in_water(player)
	local target_pos = player:get_pos()
	local target_in_node = minetest.get_node(target_pos)
	return minetest.get_item_group(target_in_node.name, "water") > 0
end

std_effects.burning = status_effects.register_effect("burning", {
	description = S("burning"),
	fold = function(self, values_by_key)
		return std_effects.util.sum_values(values_by_key, 0)
	end,
	step_every = 1,
	step_catchup = true,
	on_step = function(self, player, value, dtime)
		if value == 0 then
			return
		end
		if is_in_water(player) then
			self:clear()
			return
		end
		local hp = player:get_hp()
		player:set_hp(hp - value, { type = "set_hp", cause = "std_effects:burning" })
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
	hud_line = std_effects.util.numeric_hud_line,
})
