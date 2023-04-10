lycanthropy_effect = fmod.create()

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

if lycanthropy_effect.has.petz and petz.settings.lycanthropy then
	error("cannot have both petz lycanthropy and lycanthropy_effect lycanthropy enabled at the same time")
end

lycanthropy_effect.dofile("lycanthropy", "util")

lycanthropy_effect.dofile("lycanthropy", "lycanthropy_effect")
lycanthropy_effect.dofile("lycanthropy", "werewolf_effect")
lycanthropy_effect.dofile("lycanthropy", "chatcommands")
lycanthropy_effect.dofile("lycanthropy", "items")

lycanthropy_effect.dofile("lycanthropy", "compat")
