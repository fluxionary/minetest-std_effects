poison_effect = fmod.create()
--[[
do
	local player = minetest.get_player_by_name("flux")
	poison_effect.poison:add_time(player, 1, 10, "bad_food")
	poison_effect.poison:add_time(player, 3, 4, "stung")
end
]]
local S = poison_effect.S

poison_effect.effect = status_effects.register_effect("poison", {
	description = S("poison"),
	fold = function(self, t)
		return status_effects.fold.sum(t)
	end,
	step_every = 1,
	step_catchup = true,
	on_step = function(self, player, value, dtime)
		if value == 0 then
			return
		end
		local hp = player:get_hp()
		player:set_hp(hp - value, { type = "set_hp", cause = "poison_effect:poison" })
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
	hud_line = status_effects.hud_line.numeric,
})
