local S = std_effects.S

minetest.register_chatcommand("howl", {
	description = S("werewolf howl"),
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, S("you're not a player")
		end
		if std_effects.werewolf:value(player) then
			std_effects.werewolf:howl(player)
		else
			return false, S("you're not a werewolf")
		end
	end,
})

minetest.register_chatcommand("lycanthropy", {
	description = S("werewolf control"),
	param = S("infect [<player_name>] | cure [<player_name>] | clan [<player_name> [<clan_id>]]"),
	func = function(name, param)
		local params = param:split("%s+", false, nil, true)
		local is_admin = minetest.check_player_privs(name, "server")
		local command = params[1]
		local target
		if params[2] then
			target = canonical_name.get(params[2])
			if not target then
				return false, S("target @1 is not a player", params[2])
			end
		else
			target = name
		end
		target = minetest.get_player_by_name(target)
		if not target then
			return false, S("target must be online")
		end

		if command == "infect" then
			if not is_admin then
				return false, S("you must be an admin to run this sub-command")
			end
			std_effects.lycanthropy:infect(target)
		elseif command == "cure" then
			if not is_admin then
				return false, S("you must be an admin to run this sub-command")
			end
			std_effects.lycanthropy:cure(target)
		elseif command == "clan" then
			local clan_id = tonumber(params[3])
			if clan_id then
				if not is_admin then
					return false, S("you must be an admin to set a player's clan")
				end
				if not std_effects.werewolf_clans[clan_id] then
					return false, S("invalid clan ID, values are between 1 and @1", #std_effects.werewolf_clans)
				end
				std_effects.werewolf:set_clan(target, clan_id)
			else
				clan_id = std_effects.werewolf:get_clan(target)
				if clan_id then
					return true, std_effects.werewolf_clans[clan_id].name
				end
			end
		end
	end,
})
