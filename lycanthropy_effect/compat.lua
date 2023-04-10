if lycanthropy_effect.has["3d_armor"] then
	armor:register_on_update(function(player)
		if lycanthropy_effect.werewolf:value(player) then
			lycanthropy_effect.werewolf:_set_werewolf_appearance(player)
		end
	end)
end

if lycanthropy_effect.has.astral then
	local old_werewolf_ok = lycanthropy_effect.util.werewolf_ok
	function lycanthropy_effect.util.werewolf_ok(player)
		return astral.get_moon_phase() == 4 and old_werewolf_ok(player)
	end
end
