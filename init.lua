futil.check_version({ year = 2023, month = 3, day = 29 })

std_effects = fmod.create()

local s = std_effects.settings

std_effects.dofile("util")

if s.bleeding_enabled then
	std_effects.dofile("bleeding")
end

if s.blindness_enabled then
	std_effects.dofile("blindness")
end

if s.builders_flight_enabled then
	std_effects.dofile("builders_flight", "init")
end

if s.burning_enabled then
	std_effects.dofile("burning")
end

if s.exhaustion_enabled then
	std_effects.dofile("exhaustion")
end

if s.haste_enabled then
	std_effects.dofile("haste")
end

if s.invisibility_enabled then
	std_effects.dofile("invisibility")
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

if s.shield_enabled then
	std_effects.dofile("shield")
end

if s.slowness_enabled then
	std_effects.dofile("slowness")
end

if s.strength_enabled then
	std_effects.dofile("strength")
end

if s.stun_enabled then
	std_effects.dofile("stun")
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
