areas:registerOnAdd(function(id, area)
	area.std_effects_last_modified_time = os.time()
end)

areas:registerOnMove(function(id, area, pos1, pos2)
	area.std_effects_last_modified_time = os.time()
end)
