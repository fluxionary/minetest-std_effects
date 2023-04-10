local S = lycanthropy_effect.S

minetest.register_craftitem("lycanthropy_effect:lycanthropy_remedy", {
	description = S("Lycanthropy Remedy"),
	inventory_image = "lycanthropy_effect_lycanthropy_remedy.png",
	wield_image = "lycanthropy_effect_lycanthropy_remedy.png",
	on_use = function(itemstack, user, pointed_thing)
		if lycanthropy_effect.lycanthropy:value(user) then
			lycanthropy_effect.lycanthropy:cure(user)
			return minetest.do_item_eat(0, "vessels:glass_bottle", itemstack, user, pointed_thing)
		end
	end,
})
