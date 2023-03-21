if not std_effects.has.areas then
	std_effects.log("error", "builders flight doesn't work w/out the areas mod")
	return
end

std_effects.dofile("builders_flight", "effect")
std_effects.dofile("builders_flight", "areas")
