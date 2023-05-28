local S = lycanthropy_effect.S
local s = lycanthropy_effect.s

lycanthropy_effect.werewolf_clans = {
	{
		name = S("the savage stalkers"),
		texture = "lycanthropy_effect_werewolf_dark_gray.png",
	},
	{
		name = S("the bravehide pride"),
		texture = "lycanthropy_effect_werewolf_gray.png",
	},
	{
		name = S("the hidden tails"),
		texture = "lycanthropy_effect_werewolf_brown.png",
	},
	{
		name = S("the fierce manes"),
		texture = "lycanthropy_effect_werewolf_black.png",
	},
}

local werewolf_animations = {
	animations = {
		stand = { x = 0, y = 79 },
		lay = { x = 162, y = 166 },
		walk = { x = 168, y = 187 },
		mine = { x = 189, y = 198 },
		walk_mine = { x = 200, y = 219 },
		sit = { x = 81, y = 160 },
		-- compatibility w/ the emote mod
		wave = { x = 192, y = 196, override_local = true },
		point = { x = 196, y = 196, override_local = true },
		freeze = { x = 205, y = 205, override_local = true },
	},
}

local werewolf_model

if lycanthropy_effect.has["3d_armor"] then
	werewolf_model = "lycanthropy_effect_werewolf_3d_armor.b3d"
	werewolf_animations.textures = {
		"lycanthropy_effect_werewolf_dark_gray.png",
		"3d_armor_trans.png",
		"3d_armor_trans.png",
	}
else
	werewolf_model = "lycanthropy_effect_werewolf.b3d"
	werewolf_animations.textures = { "lycanthropy_effect_werewolf_dark_gray.png" }
end

player_api.register_model(werewolf_model, werewolf_animations)

lycanthropy_effect.werewolf = status_effects.register_effect("werewolf", {
	description = S("werewolf"),

	_set_werewolf_appearance = function(self, player)
		local meta = player:get_meta()
		local old_animation = player_api.get_animation(player)
		if old_animation.model ~= werewolf_model then
			meta:set_string("lycanthropy_effect:pre_werewolf_animation", minetest.serialize(old_animation))
		end

		player_api.set_model(player, werewolf_model)
		local clan_id = self:get_clan(player, 1)
		local werewolf_texture = lycanthropy_effect.werewolf_clans[clan_id].texture

		if minetest.get_modpath("3d_armor") then
			local player_name = player:get_player_name()
			player_api.set_textures(player, {
				werewolf_texture,
				armor.textures[player_name].armor,
				armor.textures[player_name].wielditem,
			})
		else
			player_api.set_textures(player, { werewolf_texture })
		end
	end,
	_unset_werewolf_appearance = function(self, player)
		local meta = player:get_meta()
		local pre_werewolf_animation = minetest.deserialize(meta:get("lycanthropy_effect:pre_werewolf_animation"))
		if pre_werewolf_animation then
			meta:set_string("lycanthropy_effect:pre_werewolf_animation", "")
			pre_werewolf_animation = minetest.deserialize(pre_werewolf_animation)
			if pre_werewolf_animation.model then
				player_api.set_model(player, pre_werewolf_animation.model)
			end
			if pre_werewolf_animation.textures then
				player_api.set_textures(player, pre_werewolf_animation.textures)
			end
		else
			if lycanthropy_effect.has["3d_armor"] then
				local player_name = player:get_player_name()
				player_api.set_model(player, "3d_armor_character.b3d")
				player_api.set_textures(player, {
					armor.textures[player_name].skin,
					armor.textures[player_name].armor,
					armor.textures[player_name].wielditem,
				})
			else
				player_api.set_model(player, "character.b3d")
				player_api.set_textures(player, { "character.png" })
			end
		end
	end,
	_set_werewolf_physics = function(self, player)
		player_monoids.speed:add_change(player, s.werewolf_speed, "status_effects:werewolf")
		player_monoids.jump:add_change(player, s.werewolf_jump, "status_effects:werewolf")
		player_monoids.gravity:add_change(player, s.werewolf_gravity, "status_effects:werewolf")
	end,
	_unset_werewolf_physics = function(self, player)
		player_monoids.speed:del_change(player, "status_effects:werewolf")
		player_monoids.jump:del_change(player, "status_effects:werewolf")
		player_monoids.gravity:del_change(player, "status_effects:werewolf")
	end,
	_set_werewolf_attributes = function(self, player)
		nightvision_effect.effect:add(player, "werewolf", true)
		more_player_monoids.saturation:add_change(player, 0, "werewolf")
	end,
	_unset_werewolf_attributes = function(self, player)
		nightvision_effect.effect:clear(player, "werewolf")
		more_player_monoids.saturation:del_change(player, "werewolf")
	end,
	_set_werewolf_hud = function(self, player)
		local player_name = player:get_player_name()
		local hud_id = self._hud_id_by_player_name[player_name]
		if hud_id then
			local hud_def = player:hud_get(hud_id)
			if hud_def and hud_def.name == "lycanthropy_effect:werewolf_vignette" then
				-- already showing the vignette, do nothing
				return
			end
		end
		self._hud_id_by_player_name[player_name] = player:hud_add({
			name = "lycanthropy_effect:werewolf_vignette",
			hud_elem_type = "image",
			text = "lycanthropy_effect_werewolf_vignette.png",
			position = { x = 0, y = 0 },
			scale = { x = -100, y = -100 },
			alignment = { x = 1, y = 1 },
			offset = { x = 0, y = 0 },
		})
	end,
	_unset_werewolf_hud = function(self, player)
		local player_name = player:get_player_name()
		local hud_id = self._hud_id_by_player_name[player_name]
		if hud_id then
			local hud_def = player:hud_get(hud_id)
			if hud_def and hud_def.name == "lycanthropy_effect:werewolf_vignette" then
				player:hud_remove(hud_id)
			end
		end
		self._hud_id_by_player_name[player_name] = nil
	end,
	_become_werewolf = function(self, player)
		if not self:get_clan(player) then
			self:set_clan(player, math.random(1, #lycanthropy_effect.werewolf_clans))
		end
		self:_set_werewolf_appearance(player)
		self:_set_werewolf_physics(player)
		self:_set_werewolf_attributes(player)
		self:_set_werewolf_hud(player)
		self:howl(player)
	end,
	_become_human = function(self, player)
		self:_unset_werewolf_appearance(player)
		self:_unset_werewolf_physics(player)
		self:_unset_werewolf_attributes(player)
		self:_unset_werewolf_hud(player)
	end,

	on_startup = function(self)
		self._hud_id_by_player_name = {}
	end,
	fold = function(self, t)
		return status_effects.fold.not_blocked(t)
	end,
	apply = function(self, player, value, previous_value)
		if value == true and previous_value ~= true then
			self:_become_werewolf(player)
		elseif previous_value == true and value ~= true then
			self:_become_human(player)
		end
	end,

	get_clan = function(player, default)
		local clan_id = tonumber(player:get_meta():get("lycanthropy_effect:werewolf_clan"))
		if not clan_id or not lycanthropy_effect.werewolf_clans[clan_id] then
			return default
		end
		return clan_id
	end,
	set_clan = function(player, clan_id)
		player:get_meta():set_int("lycanthropy_effect:werewolf_clan", clan_id)
	end,
	howl = function(self, player)
		if self:value(player) then
			minetest.sound_play("lycanthropy_effect_werewolf_howl", {
				pos = player:get_pos(),
				gain = 1,
				max_hear_distance = 32,
			})
		end
	end,
})
