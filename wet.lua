local S = std_effects.S

std_effects.wet = status_effects.register_effect("wet", {
	description = S("wet"),
	fold = function(self, values_by_key)
		return std_effects.util.not_blocked(values_by_key)
	end,
	apply = function(self, player, value, old_value)
		if value == true and old_value ~= true then
			player_monoids.speed:add_change(player, 0.85, "std_effects:wet")
			player_monoids.jump:add_change(player, 0.85, "std_effects:wet")
		elseif old_value == true and value ~= true then
			player_monoids.speed:del_change(player, "std_effects:wet")
			player_monoids.jump:del_change(player, "std_effects:wet")
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
	hud_line = std_effects.util.enabled_or_blocked_hud_line,
})

futil.register_globalstep({
	period = 1,
	func = function(elapsed)
		local players = minetest.get_connected_players()
		for i = 1, #players do
			local player = players[i]
			local ppos = vector.round(player:get_pos())
			local node = minetest.get_node(ppos)
			if minetest.get_item_group(node.name, "water") > 0 then
				std_effects.wet:add_timed(player, "in water", true, 60)
			elseif std_effects.wet:value(player) then
				local poss = minetest.find_nodes_in_area(vector.subtract(ppos, 2), vector.add(ppos, 2), "group:igniter")
				if #poss > 0 then
					local remaining_time = std_effects.wet:remaining_time(player, "in water")
					std_effects.wet:add_timed(player, "in water", true, remaining_time - elapsed)
				end
			end
		end
	end,
})
