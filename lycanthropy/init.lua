--[[
credit for some of this code goes to runsy in the petz mod:
* https://github.com/runsy/petz/blob/master/petz/misc/lycanthropy.lua
]]
--[[
do
    local player = minetest.get_player_by_name("flux")
    lycanthropy:add(player, true, "permanent")
end
]]

if std_effects.has.petz and petz.settings.lycanthropy then
	error("cannot have both petz lycanthropy and std_effects lycanthropy enabled at the same time")
end

std_effects.dofile("lycanthropy", "util")

std_effects.dofile("lycanthropy", "lycanthropy_effect")
std_effects.dofile("lycanthropy", "werewolf_effect")
std_effects.dofile("lycanthropy", "chatcommands")
std_effects.dofile("lycanthropy", "items")

std_effects.dofile("lycanthropy", "compat")
