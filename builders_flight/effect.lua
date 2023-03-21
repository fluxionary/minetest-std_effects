local S = std_effects.S
local s = std_effects.settings

local hud_time = status_effects.util.hud_time

std_effects.builders_flight = status_effects.register_effect("builders_flight", {
	description = S("builders' flight"),
	fold = function(self, t)
		return std_effects.util.not_blocked(t)
	end,
	apply = function(self, player, value, previous_value)
		if value == true and previous_value ~= true then
			player_monoids.fly:add_change(player, true, "status_effects:builders_flight")
			std_effects.chat_send_player(player:get_player_name(), "you feel lighter than air!")
		elseif value ~= true and previous_value == true then
			player_monoids.fly:del_change(player, "status_effects:builders_flight")
			minetest.chat_send_player(player:get_player_name(), "you feel heavy...")
		end
	end,
	step_every = s.builders_flight_check_period,
	step_catchup = false,
	on_step = function(self, player, value)
		if value == true and not self:_on_ground(player) then
			self:_show_particles(player)
		end
		if self:_in_valid_area(player) then
			self:clear(player, "builders_flight:not_in_area")
		else
			self:add(player, "builders_flight:not_in_area", false)
		end
	end,
	hud_line = function(self, player)
		local value = self:value(player, "builders_flight:item")
		if not value then
			return
		end
		local remaining = self:remaining_time(player, "builders_flight:item")
		if value == "blocked" then
			return S("@1: @2 (disabled)", self.description, hud_time(remaining))
		else
			return S("@1: @2", self.description, hud_time(remaining))
		end
	end,

	_in_valid_area = function(self, player)
		local pos = player:get_pos()
		local y = pos.y
		if y < s.builders_flight_min_elevation or y >= s.builders_flight_max_elevation then
			return false
		end

		local now = os.time()
		local player_name = player:get_player_name()
		local pmin = vector.subtract(pos, s.builders_flight_area_check_radius)
		local pmax = vector.add(pos, s.builders_flight_area_check_radius)
		local areas_at_pos = areas:getAreasIntersectingArea(pmin, pmax)
		for id, area in pairs(areas_at_pos) do
			if
				area.owner == player_name
				and (now - (area.std_effects_last_modified_time or 0) > s.builders_flight_min_valid_area_time)
			then
				return true
			end
		end
		return false
	end,
	_on_ground = function(self, player)
		local pos = vector.round(vector.offset(player:get_pos(), 0, -0.5, 0))
		local def1 = minetest.registered_nodes[minetest.get_node(pos).name]
		local def2 = minetest.registered_nodes[minetest.get_node(vector.offset(pos, 0, -1, 0)).name]
		local def3 = minetest.registered_nodes[minetest.get_node(vector.offset(pos, 0, -2, 0)).name]
		return (not def1 or def1.walkable) or (not def2 or def2.walkable) or (not def3 or def3.walkable)
	end,
	_show_particles = function(self, player)
		local pos = player:get_pos()
		local look_horizontal = player:get_look_horizontal()
		local dir = minetest.yaw_to_dir(look_horizontal)
		local minvel = -dir / 2
		local maxvel = -dir
		minvel.y = -0.5
		maxvel.y = -1

		minetest.add_particlespawner({
			amount = 5,
			time = 0.01,
			minpos = pos + vector.new(-0.25, 0, -0.25),
			maxpos = pos + vector.new(0.25, 0, 0.25),
			minvel = minvel,
			maxvel = maxvel,
			minacc = vector.new(-0.1, -0.1, -0.1),
			maxacc = vector.new(0, -1, 0),
			minexptime = 1,
			maxexptime = 2,
			minsize = 1,
			maxsize = 2.0,
			vertical = false,
			collisiondetection = true,
			texture = "std_effects_buildersflight.png",
		})
	end,
})
