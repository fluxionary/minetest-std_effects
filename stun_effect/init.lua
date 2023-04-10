stun_effect = fmod.create()
local S = stun_effect.S

-- https://gitea.your-land.de/your-land/yl_statuseffects/commit/1aae2633c40a6880e8ea14f317f649c4e1a6baf2

stun_effect.effect = status_effects.register_effect("stun", {
	description = S("stun"),
	fold = function(self, t)
		return status_effects.fold.not_blocked(t)
	end,
	apply = function(self, player, value, old_value)
		if value == true and old_value ~= true then
			player_monoids.speed:add_change(player, 0, "stun_effect:stun")
			player_monoids.jump:add_change(player, 0, "stun_effect:stun")
		elseif old_value == true and value ~= true then
			player_monoids.speed:del_change(player, "stun_effect:stun")
			player_monoids.jump:del_change(player, "stun_effect:stun")
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
	hud_line = status_effects.hud_line.enabled_or_blocked,
})
