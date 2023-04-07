local S = std_effects.S

std_effects.exhaustion = status_effects.register_effect("exhaustion", {
	description = S("exhaustion"),
	fold = function(self, values_by_key)
		return std_effects.util.sum_values(values_by_key)
	end,
	step_every = 1,
	step_catchup = false,
	on_step = function(self, player, value, dtime)
		local wielded_item = player:get_wielded_item()
		local old_groupcaps = wielded_item:get_tool_capabilities()
		if value <= 0 then
			toolcap_monoids.full_punch:del_change(wielded_item, "std_effects:exhaustion")
			toolcap_monoids.dig_speed:del_change(wielded_item, "std_effects:exhaustion")
			player_monoids.speed:del_change(player, "std_effects:exhaustion")
			player_monoids.jump:del_change(player, "std_effects:exhaustion")
		else
			toolcap_monoids.full_punch:add_change(wielded_item, math.pow(value + 1, 1), "std_effects:exhaustion")
			toolcap_monoids.dig_speed:add_change(wielded_item, math.pow(value + 1, 1), "std_effects:exhaustion")
			player_monoids.speed:add_change(player, math.pow(1 / 1.8, value), "std_effects:exhaustion")
			player_monoids.jump:add_change(player, math.pow(1 / 1.1, value), "std_effects:exhaustion")
		end
		local new_groupcaps = wielded_item:get_tool_capabilities()
		if not futil.equals(old_groupcaps, new_groupcaps) then
			player:set_wielded_item(wielded_item)
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
})

local old_handle_node_drops = minetest.handle_node_drops

function minetest.handle_node_drops(pos, drops, digger)
	if std_effects.exhaustion:value(digger) >= 1 then
		for _, drop in ipairs(drops) do
			minetest.add_item(pos, drop)
		end
	else
		old_handle_node_drops(pos, drops, digger)
	end
end
