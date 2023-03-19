if std_effects.has["3d_armor"] then
	armor:register_on_update(function(player)
		if std_effects.werewolf:value(player) then
			std_effects.werewolf:_set_werewolf_appearance(player)
		end
	end)
end

if std_effects.has.astral then
	local old_werewolf_ok = std_effects.util.werewolf_ok
	function std_effects.util.werewolf_ok(player)
		return astral.get_moon_phase() == 4 and old_werewolf_ok(player)
	end
end
