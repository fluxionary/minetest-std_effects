local f = string.format
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

function std_effects.util.boolean_hud_line(self, player)
	local value = self:value(player)
	if type(value) ~= "boolean" then
		error(f("%s: invalid value of type %s for boolean hud line", self.name, type(value)))
	end
	if not value then
		return
	end
	local remaining = self:remaining_time(player)
	if remaining == inf then
		return S("@1", self.description)
	else
		return S("@1 (@3s)", self.description, f("%.1f", remaining))
	end
end

function std_effects.util.numeric_hud_line(self, player)
	local value = self:value(player)
	if type(value) ~= "number" then
		error(f("%s: invalid value of type %s for numeric hud line", self.name, type(value)))
	end
	if value == 0 then
		return
	end
	local remaining = self:remaining_time(player)
	if remaining == inf then
		return S("@1=@2", self.description, f("%.1f", value))
	else
		return S("@1=@2 (@3s)", self.description, f("%.1f", value), f("%.1f", remaining))
	end
end

function std_effects.util.enabled_or_blocked_hud_line(self, player)
	local value = self:value(player)
	if value == false or value == nil then
		return
	end

	local remaining = self:remaining_time(player)

	if value == "blocked" then
		if remaining == inf then
			return S("@1 blocked", self.description)
		else
			return S("@1 blocked (@2s)", self.description, f("%.1f", remaining))
		end
	elseif value then
		if remaining == inf then
			return self.description
		else
			return S("@1 (@2s)", self.description, f("%.1f", remaining))
		end
	end
end
