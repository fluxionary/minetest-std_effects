--[[
	function(player)
		player:set_breath(player:get_breath()-4)
		if player:get_breath() < 4 then
			player:set_breath(1)
		end
	end,
]]
