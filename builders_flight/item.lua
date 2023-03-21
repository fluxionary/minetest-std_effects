local S = std_effects.S
local s = std_effects.settings

minetest.register_craftitem("std_effects:builders_flight", {
	description = S("builders' flight"),
	inventory_image = "std_effects_buildersflight.png",
	wield_image = "std_effects_buildersflight.png",
	on_use = function(itemstack, user, pointed_thing)
		if not minetest.is_player(user) then
			return
		end

		local user_name = user:get_player_name()
		local had_builders_flight = std_effects.builders_flight:value(user)

		if minetest.check_player_privs(user, "fly") and not had_builders_flight then
			std_effects.chat_send_player(user_name, "you don't need this potion :)")
			return
		end

		std_effects.builders_flight:add_timed(user, "builders_flight:item", true, s.builders_flight_item_duration)

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
