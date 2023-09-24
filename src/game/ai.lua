---@class AI
Classes.ai = Clazz()

---@param game GameState
function Classes.ai:init(game)
	self.game = game
	self.negatives = { }
end

local function shuffleInPlace(t)
	for i = #t, 2, -1 do
		local j = math.random(i)
		t[i], t[j] = t[j], t[i]
	end
end

function Classes.ai:nextTurn()
	self.tasks = nil
	if not self.game.isPlayerTurn and not self.game.humanPlayerTwo then
		self.tasks = {}
		while #self.tasks < 500 do
			for _, movementType in ipairs({
				{ direction = "left",  jumping = false },
				{ direction = "left",  jumping = true },
				{ direction = "",      jumping = false },
				{ direction = "",      jumping = true },
				{ direction = "right", jumping = true },
				{ direction = "right", jumping = false },
			}) do
				for name, weapon in pairs(Weapons) do
					if self.game.inventory:canAfford(weapon) then
						table.insert(self.tasks, {
							movementType = movementType,
							weapon = name,
							aim = (math.random() - 0.5) * math.pi,
							power = weapon.power and math.random() or 1
						})
					end
				end
			end
		end

		shuffleInPlace(self.tasks)
	end

	self.bestTask = self.tasks and self.tasks[0]
	self.bestScore = -1000
end

function Classes.ai:play(game, task)
	local e = game:getCurrentEntity()

	if game.state == "move" or game.state == "idle" then
		e:control(
			task.movementType.direction == "left",
			task.movementType.direction == "right",
			task.movementType.jumping,
			not task.movementType.jumping and task.movementType.direction == ""
		)

		if game.turnTimer > 5 then
			if not game.weapon then
				game.weapon = Weapons[task.weapon](game)
				self.negatives[task.weapon] = (self.negatives[task.weapon] or 0) + 1
			end
			game:aim()
		end
	elseif game.state == "aim" then
		e.aim = task.aim
		game.power = task.power
		game:trigger()
	end
end

function Classes.ai:test(task)
	local game = self.game:clone()
	local turn = game.turn
	local i = 0
	while turn == game.turn and game.turnTimer < 30 and i < 300 do
		self:play(game, task)
		game:updateInner(1 / 20)
		i = i + 1
	end

	local score = game:getScore()
	if score > 0 then
		score = score / ((self.negatives[task.weapon] or 0) + 1)
	end
	if score > self.bestScore then
		self.bestScore = score
		self.bestTask = task
	end
end

function Classes.ai:update()
	if not self.tasks then
		return
	end

	local t = love.timer.getTime()
	while love.timer.getTime() - t < 10 / 1000 and #self.tasks > 0 do
		self:test(table.remove(self.tasks))
	end

	if #self.tasks == 0 then
		self:play(self.game, self.bestTask)
	else
		self.game.turnTimer = 0
	end
end

function Classes.ai:playLike(game, movementMode, attackMode)

end
