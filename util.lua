local S = std_effects.S
local inf = tonumber("inf")

std_effects.util = {}

function std_effects.util.not_blocked(t)
	local enabled = false
	local blocked = false
	for _, value in pairs(t) do
		if value then
			enabled = true
		else
			blocked = true
		end
	end
	if blocked then
		return "blocked"
	else
		return enabled
	end
end

function std_effects.util.nothing_false(t)
	return not futil.table.is_empty(t) and futil.functional.iall(futil.iterators.values(t))
end

function std_effects.util.any_value(t)
	return futil.functional.iany(futil.iterators.values(t))
end

function std_effects.util.sum_values(t, default)
	return futil.math.isum(futil.iterators.values(t), default or 0)
end

function std_effects.util.max_values(t, default)
	local max = default
	for _, value in pairs(t) do
		if value > max then
			max = value
		end
	end
	return max
end

function std_effects.util.numeric_hud_line(self, player)
	local value = self:value(player)
	local remaining = self:remaining_time(player)
	if value == 0 then
		return
	end
	if remaining == inf then
		return S("@1=@2", self.description, value)
	else
		return S("@1=@2 (@3s)", self.description, value, remaining)
	end
end

function std_effects.util.enabled_or_blocked_hud_line(self, player)
	local value = self:value(player)
	local remaining = self:remaining_time(player)
	if value == false or value == nil then
		return
	end

	if value == "blocked" then
		if remaining == inf then
			return S("@1 blocked", self.description)
		else
			return S("@1 blocked (@2s)", self.description, remaining)
		end
	else
		if remaining == inf then
			return self.description
		else
			return S("@1 (@2s)", self.description, remaining)
		end
	end
end
