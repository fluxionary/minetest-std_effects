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

lycanthropy_effect.dofile("util")

lycanthropy_effect.dofile("lycanthropy_effect")
lycanthropy_effect.dofile("werewolf_effect")
lycanthropy_effect.dofile("chatcommands")
lycanthropy_effect.dofile("items")

lycanthropy_effect.dofile("compat")
