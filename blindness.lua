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
local S = std_effects.S

std_effects.blindness_hud = futil.define_hud("status_effects:blindness", {
	get_hud_def = function(player)
		return {
			name = "status_effects:blindness",
			hud_elem_type = "image",
			position = { x = 0.5, y = 0.5 },
			scale = { x = -100, y = -100 },
			text = "[combine:16x16^[noalpha^[colorize:#000:255",
		}
	end,
})

std_effects.blindness = status_effects.register_effect("blindness", {
	description = S("blindness"),
	fold = function(self, values_by_key)
		return std_effects.util.not_blocked(values_by_key)
	end,
	apply = function(self, player, value, old_value)
		if value == true and old_value ~= true then
			std_effects.blindness_hud:set_enabled(player, true)
		elseif old_value == true and value ~= true then
			std_effects.blindness_hud:set_enabled(player, false)
		end
	end,
	hud_line = std_effects.util.enabled_or_blocked_hud_line,
})
