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

std_effects.blindness = status_effects.register_effect("blindness", {
	on_startup = function(self)
		self._hud_id_by_player_name = {}
	end,
	fold = function(self, t)
		return not futil.table.is_empty(t) and futil.functional.iall(futil.iterators.values(t))
	end,
	apply = function(self, player, value)
		local player_name = player:get_player_name()
		local hud_id = self._hud_id_by_player_name[player_name]
		if value then
			if not hud_id then
				hud_id = player:hud_add({
					name = "status_effects:blindness",
					hud_elem_type = "image",
					position = { x = 0.5, y = 0.5 },
					scale = { x = -100, y = -100 },
					text = "[combine:16x16^[noalpha^[colorize:#000:255",
				})
				self._hud_id_by_player_name[player_name] = hud_id
			end
		else
			if hud_id then
				local hud_def = player:hud_get(hud_id)
				if hud_def.name == "status_effects:blindness" then
					player:hud_remove(hud_id)
				end
				self._hud_id_by_player_name[player_name] = nil
			end
		end
	end,
})
