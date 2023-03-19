local fov_scale = 0.5
local fov_speed = 1

std_effects.tipsy = status_effects.register_effect("tipsy", {
	on_startup = function(self)
		self._fov_elapsed_by_player_name = {}
	end,
	fold = function(self, t)
		return futil.math.sum(t, 0)
	end,
	step_every = 1,
	step_catchup = true,
	on_step = function(self, player, value, dtime)
		if value <= 0 then
			return
		end
		if value <= 1 then
			self:_reset_fov(player)
			self._clear_poison(player)
		end
		if value >= 2 then
			self:_advance_fov(player, dtime)
			if math.random(1, 20) == 1 then
				self:_burp(player)
			end
		end
		if value >= 5 then
			self:_randomize_look(player)
		end
		if value >= 10 then
			self:_poison(player, value - 9)
		end
	end,
	on_die = function(self, player)
		self:clear(player)
	end,

	_reset_fov = function(self, player)
		-- TODO fov_monoid
		local player_name = player:get_player_name()
		self._fov_elapsed_by_player_name[player_name] = nil
		player:set_fov(0)
	end,
	_advance_fov = function(self, player, dtime)
		-- TODO fov_monoid
		local player_name = player:get_player_name()
		local elapsed = (self._fov_elapsed_by_player_name[player_name] or 0) + dtime
		self._fov_elapsed_by_player_name[player_name] = elapsed
		local x = (elapsed * fov_speed) % 6.283185307179586
		local fov_multiplier = fov_scale * math.sin(x)
		player:set_fov(fov_multiplier, true, 1)
	end,
	_randomize_look = function(self, player)
		if not player:get_attach() then
			player:set_look_horizontal(player:get_look_horizontal() + math.random(-0.5, 0.5))
			player:set_look_vertical(math.random(-math.pi / 2, math.pi / 2))
		end
	end,
	_burp = function(self, player)
		local eye_height = player:get_properties().eye_height
		local pos = player:get_pos()
		pos.y = pos.y + eye_height
		local dir = player:get_look_dir()
		minetest.add_particlespawner({
			amount = 5,
			time = 0.1,
			minpos = pos,
			maxpos = pos,
			minvel = { x = dir.x - 1, y = dir.y, z = dir.z - 1 },
			maxvel = { x = dir.x + 1, y = dir.y, z = dir.z + 1 },
			minacc = { x = 0, y = -5, z = 0 },
			maxacc = { x = 0, y = -9, z = 0 },
			minexptime = 1,
			maxexptime = 1,
			minsize = 1,
			maxsize = 2,
			texture = "bubble.png",
		})
		minetest.sound_play("yl_statuseffects_burp", { to_player = player:get_player_name(), gain = 0.7 }, true)
	end,
	_poison = function(self, player, amount)
		std_effects.poison:add(player, amount, "std_effects:tipsy")
	end,
	_clear_poison = function(self, player)
		std_effects.poison:clear(player, "std_effects:tipsy")
	end,
})
