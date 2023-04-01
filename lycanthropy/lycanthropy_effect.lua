local S = std_effects.S
local s = std_effects.settings

std_effects.lycanthropy = status_effects.register_effect("lycanthropy", {
	description = S("lycanthropy"),
	fold = function(self, t)
		return std_effects.util.any_value(t)
	end,
	step_every = 1,
	step_catchup = false,
	on_step = function(self, player, value)
		local is_werewolf = std_effects.werewolf:value(player)
		if value then
			local can_be_werewolf = std_effects.util.werewolf_ok(player)
			if can_be_werewolf and not is_werewolf then
				std_effects.werewolf:add(player, "lycanthropy", true)
			elseif is_werewolf and not can_be_werewolf then
				std_effects.werewolf:clear(player, "lycanthropy")
			end
		else
			if is_werewolf then
				std_effects.werewolf:clear(player, "lycanthropy")
			end
		end
	end,

	infect = function(self, player)
		self:set(player, true, "infection")
		std_effects.werewolf:add_time(player, "infection", true, s.infection_time)
	end,
	cure = function(self, player)
		self:clear(player)
		std_effects.werewolf:clear(player)
	end,
})
