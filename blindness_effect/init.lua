blindness_effect = fmod.create()

local S = blindness_effect.S

blindness_effect.hud = futil.define_hud("blindness_effect:hud", {
	get_hud_def = function(player)
		return {
			name = "blindness_effect:hud",
			hud_elem_type = "image",
			position = { x = 0.5, y = 0.5 },
			scale = { x = -100, y = -100 },
			text = "[combine:16x16^[noalpha^[colorize:#000:255",
		}
	end,
})

blindness_effect.effect = status_effects.register_effect("blindness", {
	description = S("blindness"),
	fold = function(self, values_by_key)
		return status_effects.fold.not_blocked(values_by_key)
	end,
	apply = function(self, player, value, old_value)
		if value == true and old_value ~= true then
			blindness_effect.hud:set_enabled(player, true)
		elseif old_value == true and value ~= true then
			blindness_effect.hud:set_enabled(player, false)
		end
	end,
	-- TODO on_joinplayer ? or does futil handle that?
	hud_line = status_effects.hud_line.enabled_or_blocked,
})

--[[
do
    local player = minetest.get_player_by_name("flux")
    blindness:add_time(player, "blinded", true, 60)  -- add 60 seconds of blindness
end

minetest.after(5, function()
    local player = minetest.get_player_by_name("flux")
    blindness:add_time(player, "blinded", true, 5)  -- override the timer
end)

minetest.register_craftitem("mymod:blindness_cure", {
    on_use = function(itemstack, user, pointed_thing)
        if not minetest.is_creative_enabled(user) then
            itemstack:take_item()
        end
        blindness:clear(user, true, "blinded")  -- remove blindness
        blindness:add_time(user, "cured", false, 60)  -- add 60 seconds of protection against getting the effect again
        return itemstack
    end,
})
]]
