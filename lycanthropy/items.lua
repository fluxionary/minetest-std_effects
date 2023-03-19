local S = std_effects.S

minetest.register_craftitem("std_effects:lycanthropy_remedy", {
	description = S("Lycanthropy Remedy"),
	inventory_image = "std_effects_lycanthropy_remedy.png",
	wield_image = "std_effects_lycanthropy_remedy.png",
	on_use = function(itemstack, user, pointed_thing)
		if std_effects.lycanthropy:value(user) then
			std_effects.lycanthropy:cure(user)
			return minetest.do_item_eat(0, "vessels:glass_bottle", itemstack, user, pointed_thing)
		end
	end,
})
