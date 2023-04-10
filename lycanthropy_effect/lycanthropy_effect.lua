local S = lycanthropy_effect.S
local s = lycanthropy_effect.settings

lycanthropy_effect.lycanthropy = status_effects.register_effect("lycanthropy", {
	description = S("lycanthropy"),
	fold = function(self, t)
		return status_effects.fold.any_value(t)
	end,
	step_every = 1,
	step_catchup = false,
	on_step = function(self, player, value)
		local is_werewolf = lycanthropy_effect.werewolf:value(player)
		if value then
			local can_be_werewolf = lycanthropy_effect.werewolf_ok(player)
			if can_be_werewolf and not is_werewolf then
				lycanthropy_effect.werewolf:add(player, "lycanthropy", true)
			elseif is_werewolf and not can_be_werewolf then
				lycanthropy_effect.werewolf:clear(player, "lycanthropy")
			end
		else
			if is_werewolf then
				lycanthropy_effect.werewolf:clear(player, "lycanthropy")
			end
		end
	end,

	infect = function(self, player)
		self:set(player, true, "infection")
		lycanthropy_effect.werewolf:add_time(player, "infection", true, s.infection_time)
	end,
	cure = function(self, player)
		self:clear(player)
		lycanthropy_effect.werewolf:clear(player)
	end,
})
