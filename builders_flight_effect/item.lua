local S = builders_flight_effect.S
local s = builders_flight_effect.settings

minetest.register_craftitem("builders_flight_effect:builders_flight", {
	description = S("builders' flight"),
	inventory_image = "builders_flight_effect_buildersflight.png",
	wield_image = "builders_flight_effect_buildersflight.png",
	on_use = function(itemstack, user, pointed_thing)
		if not minetest.is_player(user) then
			return
		end

		local user_name = user:get_player_name()
		local had_builders_flight = builders_flight_effect.effect:value(user)

		if minetest.check_player_privs(user, "fly") and not had_builders_flight then
			builders_flight_effect.chat_send_player(user_name, "you don't need this potion :)")
			return
		end

		builders_flight_effect.effect:add_timed(user, "builders_flight:item", true, s.duration)

		if not had_builders_flight then
			minetest.chat_send_player(
				user_name,
				"you can fly in areas you own, if they are at least @1s old. "
					.. "use the `/toggle_status_effects_hud` command to see how long you can fly.",
				s.builders_flight_min_valid_area_time
			)
		end

		if not minetest.check_player_privs(user, "creative") then
			itemstack:take_item(1)
		end

		return itemstack
	end,
})
