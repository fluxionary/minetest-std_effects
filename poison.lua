--[[
do
	local player = minetest.get_player_by_name("flux")
	std_effects.poison:add_time(player, 1, 10, "bad_food")
	std_effects.poison:add_time(player, 3, 4, "stung")
end
]]
local S = std_effects.S

std_effects.poison = status_effects.register_effect("poison", {
	description = S("poison"),
	fold = function(self, t)
		return std_effects.util.sum_values(t)
	end,
	step_every = 1,
	step_catchup = true,
	on_step = function(self, player, value, dtime)
		if value == 0 then
			return
		end
		local hp = player:get_hp()
		player:set_hp(hp - value, { type = "set_hp", cause = "std_effects:poison" })
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
	hud_line = std_effects.util.numeric_hud_line,
})
