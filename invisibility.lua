local S = std_effects.S

std_effects.invisibility = status_effects.register_effect("invisibility", {
	description = S("invisibility"),
	fold = function(self, t)
		return std_effects.util.any_value(t)
	end,
	apply = function(self, player, value, old_value)
		if value and not old_value then
			self._hide_textures(player)
			self._hide_name(player)
		elseif old_value and not value then
			self._unhide_textures(player)
			self._unhide_name(player)
		end
	end,
	hud_line = std_effects.util.boolean_hud_line,

	_hide_textures = function(player)
		local meta = player:get_meta()
		local old_textures = player_api.get_animation(player).textures
		if old_textures and old_textures[1] and old_textures[1] ~= "blank.png" then
			meta:set_string("std_effects:pre_invisible_textures", minetest.serialize(old_textures))
		end
		local textures = table.copy(old_textures)
		textures[1] = "blank.png"
		player_api.set_textures(player, textures)
	end,
	_unhide_textures = function(player)
		local meta = player:get_meta()
		local pre_invisible_textures = minetest.deserialize(meta:get("std_effects:pre_invisible_textures"))
		if pre_invisible_textures then
			player_api.set_textures(player, pre_invisible_textures)
		end
	end,
	_hide_name = function(player)
		name_monoid.monoid:add_change(player, { hide_all = true }, "invisibility")
	end,
	_unhide_name = function(player)
		name_monoid.monoid:del_change(player, "invisibility")
	end,
})

if std_effects.has["3d_armor"] then
	armor:register_on_update(function(player)
		if std_effects.invisibility:value(player) then
			std_effects.invisibility:_hide_textures(player)
		end
	end)
end
