exhaustion_effect = fmod.create()

local S = exhaustion_effect.S
local s = exhaustion_effect.settings
local has = exhaustion_effect.has

exhaustion_effect.effect = status_effects.register_effect("exhaustion", {
	description = S("exhaustion"),
	fold = function(self, values_by_key)
		return status_effects.fold.sum(values_by_key)
	end,
	on_startup = function(self)
		self._sound_handle_by_player_name = {}
	end,
	on_leaveplayer = function(self, player, timed_out)
		self._sound_handle_by_player_name[player:get_player_name()] = nil
	end,
	step_every = 1,
	step_catchup = false,
	on_step = function(self, player, value, dtime)
		local wielded_item = player:get_wielded_item()
		local old_groupcaps = wielded_item:get_tool_capabilities()
		local player_name = player:get_player_name()
		if value <= 0 then
			if has.toolcap_monoids then
				toolcap_monoids.full_punch:del_change(wielded_item, "exhaustion_effect:exhaustion")
				toolcap_monoids.dig_speed:del_change(wielded_item, "exhaustion_effect:exhaustion")
			end
			player_monoids.speed:del_change(player, "exhaustion_effect:exhaustion")
			player_monoids.jump:del_change(player, "exhaustion_effect:exhaustion")
			local handle = self._sound_handle_by_player_name[player_name]
			if handle then
				minetest.sound_fade(handle, 1, 0)
				self._sound_handle_by_player_name[player_name] = nil
			end
		else
			if has.toolcap_monoids then
				toolcap_monoids.full_punch:add_change(
					wielded_item,
					math.pow(value + 1, s.full_punch_gamma),
					"exhaustion_effect:exhaustion"
				)
				toolcap_monoids.dig_speed:add_change(
					wielded_item,
					math.pow(value + 1, s.dig_speed_gamma),
					"exhaustion_effect:exhaustion"
				)
			end
			player_monoids.speed:add_change(player, math.pow(s.speed_drop, value), "exhaustion_effect:exhaustion")
			player_monoids.jump:add_change(player, math.pow(s.jump_drop, value), "exhaustion_effect:exhaustion")
			if not self._sound_handle_by_player_name[player_name] then
				self._sound_handle_by_player_name[player_name] = minetest.sound_play("exhaustion_effect_exhausted", {
					to_player = player_name,
					loop = true,
				})
			end
		end
		local new_groupcaps = wielded_item:get_tool_capabilities()
		if not futil.equals(old_groupcaps, new_groupcaps) then
			player:set_wielded_item(wielded_item)
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,
})

local old_handle_node_drops = minetest.handle_node_drops

function minetest.handle_node_drops(pos, drops, digger)
	if not futil.is_player(digger) then
		old_handle_node_drops(pos, drops, digger)
	elseif exhaustion_effect.effect:value(digger) >= 1 then
		for _, drop in ipairs(drops) do
			minetest.add_item(pos, drop)
		end
	else
		old_handle_node_drops(pos, drops, digger)
	end
end

local old_builtin_item_on_punch = minetest.registered_entities["__builtin:item"].on_punch

minetest.registered_entities["__builtin:item"].on_punch = function(self, hitter, ...)
	if not futil.is_player(hitter) or exhaustion_effect.effect:value(hitter) < 1 then
		return old_builtin_item_on_punch(self, hitter, ...)
	end
end
