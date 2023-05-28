wet_effect = fmod.create()
local S = wet_effect.S

local has_staminoid = wet_effect.has.staminoid

wet_effect.effect = status_effects.register_effect("wet", {
	description = S("wet"),
	fold = function(self, values_by_key)
		return status_effects.fold.not_blocked(values_by_key)
	end,
	apply = function(self, player, value, old_value)
		if value == true and old_value ~= true then
			-- TODO constants -> settings
			player_monoids.speed:add_change(player, 0.85, "wet_effect")
			if has_staminoid then
				staminoid.stamina_regen_effect:add(player, "wet_effect", { multiplier = 0.75 })
			end
		elseif old_value == true and value ~= true then
			player_monoids.speed:del_change(player, "wet_effect")
			if has_staminoid then
				staminoid.stamina_regen_effect:clear(player, "wet_effect")
			end
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
	hud_line = status_effects.hud_line.enabled_or_blocked,
})

futil.register_globalstep({
	period = 1,
	func = function(elapsed)
		local players = minetest.get_connected_players()
		for i = 1, #players do
			local player = players[i]
			local ppos = player:get_pos()
			local pos = vector.round(vector.offset(ppos, 0, 0.25, 0)) -- don't get wet if just your toes are in water
			local node = minetest.get_node(pos)
			if minetest.get_item_group(node.name, "water") > 0 then
				wet_effect.effect:add_timed(player, "in water", true, 60)
			elseif wet_effect.effect:value(player) then
				local p1 = vector.subtract(pos, 2)
				local p2 = vector.add(pos, 2)
				local poss_by_igniter = minetest.find_nodes_in_area(p1, p2, "group:igniter", true)
				local heat = 0
				for igniter, poss in pairs(poss_by_igniter) do
					local strength = 2 / minetest.get_item_group(igniter, "igniter")
					for _, pos2 in ipairs(poss) do
						heat = heat + (strength / math.max(1, vector.distance(ppos, pos2)))
					end
				end
				if heat > 0 then
					local remaining_time = wet_effect.effect:remaining_time(player, "in water")
					wet_effect.effect:add_timed(player, "in water", true, remaining_time - (elapsed * heat))
				end
			end
		end
	end,
})
