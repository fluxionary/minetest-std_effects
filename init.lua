futil.check_version({ year = 2023, month = 3, day = 29 })

std_effects = fmod.create()

local s = std_effects.settings

std_effects.dofile("util")

if s.bleeding_enabled then
	std_effects.dofile("bleeding")
end

if s.blind_enabled then
	std_effects.dofile("blind")
end

if s.builders_flight_enabled then
	std_effects.dofile("builders_flight", "init")
end

if s.burning_enabled then
	std_effects.dofile("burning")
end

if s.invisible_enabled then
	std_effects.dofile("invisible")
end

if s.lycanthropy_enabled then
	std_effects.dofile("lycanthropy", "init")
end

if s.poison_enabled then
	std_effects.dofile("poison")
end

if s.regen_enabled then
	std_effects.dofile("regen")
end

if s.shielded_enabled then
	std_effects.dofile("shielded")
end

if s.slow_enabled then
	std_effects.dofile("slow")
end

if s.speed_enabled then
	std_effects.dofile("speed")
end

if s.strength_enabled then
	std_effects.dofile("strength")
end

if s.stunned_enabled then
	std_effects.dofile("stunned")
end

if s.tipsy_enabled then
	std_effects.dofile("tipsy")
end

if s.water_breathing_enabled then
	std_effects.dofile("water_breathing")
end

if s.weakness then
	std_effects.dofile("weakness")
end
