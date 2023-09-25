---@class GameState : State
Classes.game = Clazz()

require("src.game.blocks")
require("src.game.level")
require("src.game.inventory")
require("src.game.weapons")
require("src.game.resources")
require("src.game.ai")
require("src.game.particle")

--load entity types
for _, name in ipairs(love.filesystem.getDirectoryItems("src/game/entities")) do
	require("src.game.entities." .. name:sub(1, #name - 4))
end

Classes.worm = require("src.game.entities.worm")

---Initializes a new game
---@param level number
---@param humanPlayerTwo boolean
function Classes.game:init(level, humanPlayerTwo)
	---@type Level
	self.level = Classes.level(level)

	self.humanPlayerTwo = humanPlayerTwo

	self.lastEntityID = 0

	---@type Entity[]
	self.entities = {}

	---spawn the bois
	local spawnsA = self.level.spawns[self.humanPlayerTwo and "ma" or "sa"]
	for _, pos in ipairs(#spawnsA == 0 and self.level.spawns.sa or spawnsA) do
		self:addEntity(Classes.worm(self, false, pos[1], pos[2]))
	end
	local spawnsB = self.level.spawns[self.humanPlayerTwo and "mb" or "sb"]
	for _, pos in ipairs(#spawnsB == 0 and self.level.spawns.sb or spawnsB) do
		self:addEntity(Classes.worm(self, true, pos[1], pos[2]))
	end

	self.currentPlayer = false
	self.currentEnemy = false
	self.isPlayerTurn = false

	---@type AI
	self.ai = Classes.ai(self)

	self.inventoryOpen = false

	---@type Inventory
	self.inventory = Classes.inventory(self)

	---@type Resources
	self.resourcesA = Classes.resources()

	---@type Resources
	self.resourcesB = Classes.resources(self.resourcesA)

	self.turn = 0
	self:nextTurn()
end

function Classes.game:switch()
	PlayMusic("war")
end

---Returns the current entity
---@return WormEntity
function Classes.game:getCurrentEntity()
	---@diagnostic disable-next-line: return-type-mismatch
	return self.isPlayerTurn and self.currentPlayer or self.currentEnemy
end

---Returns the current resources
---@return Resources
function Classes.game:getCurrentResources()
	---@diagnostic disable-next-line: return-type-mismatch
	return self.isPlayerTurn and self.resourcesA or self.resourcesB
end

function Classes.game:addEntity(entity)
	self.lastEntityID = self.lastEntityID + 1
	entity.index = self.lastEntityID
	table.insert(self.entities, entity)
end

function Classes.game:nextTurn()
	self.isPlayerTurn = not self.isPlayerTurn
	self.turnTimer = 0

	self.turn = self.turn + 1

	self.showTeam = true

	self:nextEntity()

	local e = self:getCurrentEntity()
	self.startX = e.x
	self.startY = e.y

	self.state = "move"
	self.power = 1
	self.endTurnTimer = 1
	self.maxDistance = 20

	---@type Weapon
	self.weapon = nil

	for _, entity in ipairs(self.entities) do
		entity:nextTurn()
	end

	self.ai:nextTurn()
end

function Classes.game:nextEntity()
	local search = false
	for i = 1, 2 do
		for _, entity in ipairs(self.entities) do
			if entity == self:getCurrentEntity() then
				search = true
			elseif search then
				---@cast entity WormEntity
				if entity:instanceOf(Classes.worm) and entity.enemy ~= self.isPlayerTurn then
					if self.isPlayerTurn then
						self.currentPlayer = entity
					else
						self.currentEnemy = entity
					end
					return
				end
			end
		end
		search = true
	end
end

function Classes.game:draw()
	love.graphics.clear()

	if self.inventoryOpen then
		self.inventory:draw()
	else
		-- world
		love.graphics.setShader(TextureShader)
		local frame = math.floor(love.timer.getTime() * 3) % 4

		local tex = Texture.tiles["water_" .. frame]
		tex:setWrap("repeat")
		TextureShader:send("water", tex)

		local tex = Texture.tiles.lava
		tex:setWrap("repeat")
		TextureShader:send("lava", tex)

		local tex = Texture.tiles.schmiamand
		tex:setWrap("repeat")
		TextureShader:send("schmiamand", tex)

		TextureShader:send("animation", { 0, -love.timer.getTime() / self.level.height * 1.5 })
		TextureShader:send("waterScale", { self.level.width / 18, self.level.height / 18 })
		love.graphics.draw(self.level:getImage())
		love.graphics.setShader()

		-- entities
		for _, entity in ipairs(self.entities) do
			entity:draw()
		end

		for _, particle in ipairs(self.level.particles) do
			particle:draw()
		end

		-- highlight team
		if self.showTeam then
			for _, entity in ipairs(self.entities) do
				---@cast entity WormEntity
				if entity:instanceOf(Classes.worm) and entity.enemy ~= self.isPlayerTurn then
					if entity == self:getCurrentEntity() then
						if (love.timer.getTime() % 2) > 1 then
							love.graphics.draw(Texture.arrow, math.floor(entity:getCenterX() + 1),
								math.floor(entity:getCenterY() - 11), math.pi / 2)
						else
							love.graphics.draw(Texture.arrow2, math.floor(entity:getCenterX() + 1),
								math.floor(entity:getCenterY() - 12), math.pi / 2)
						end
					else
						love.graphics.draw(Texture.dot, math.floor(entity:getCenterX() - 1),
							math.floor(entity:getCenterY() - 7),
							math.floor(love.timer.getTime() * 2 + entity.seed) * math.pi / 4, 1, 1, 1, 1)
					end
				end
			end
		end

		-- overlay
		love.graphics.draw(Texture.ingameMenu)
		if self.state == "idle" then
			love.graphics.print("...", 118, 130)
		end
		if self.weapon then
			love.graphics.draw(self.weapon.icon, 138, 122)
		end

		-- who's turn is it
		love.graphics.setColor(0.3, 0.3, 0.3)
		if self.turnTimer < 3 then
			love.graphics.printf(self.isPlayerTurn and "player's turn" or "enemy's turn", 0, 5, Globals.width, "center")
		end
		love.graphics.setColor(1, 1, 1)

		love.graphics.rectangle("fill", 110, 130, self.power * 20, 8)

		local fy = 0
		local ey = 0
		for _, entity in ipairs(self.entities) do
			if entity:instanceOf(Classes.worm) then
				---@cast entity WormEntity
				local x, y
				if entity.enemy then
					x = 60
					ey = ey + 1
					y = 127 + (ey - 1) * 4
				else
					x = 10
					fy = fy + 1
					y = 127 + (fy - 1) * 4
				end

				love.graphics.setColor(0.25, 0.25, 0.25)
				love.graphics.rectangle("fill", x, y, entity.lazyHealth * 40, 2)
				love.graphics.setColor(1.0, 1.0, 1.0)
				love.graphics.rectangle("fill", x, y, entity.health * 40, 2)

				if entity == self:getCurrentEntity() then
					if (love.timer.getTime() % 2) > 1 then
						love.graphics.draw(Texture.arrow, x - 7, y - 1)
					else
						love.graphics.draw(Texture.arrow2, x - 7, y - 1)
					end
				end
			end
		end

		-- weapon overlay
		if self.state == "aim" then
			self.weapon:draw()
		end
	end
end

function Classes.game:update(dt)
	-- Control entity
	local e = self:getCurrentEntity()

	if self.isPlayerTurn or self.humanPlayerTwo then
		if not self.inventoryOpen then
			e:control(
				Key.Left(),
				Key.Right(),
				Key.Up(),
				Key.Down()
			)
		end
	end

	if self.turnTimer > 0.01 and (e.pressingRight or e.pressingLeft) then
		self.showTeam = false
	end

	self:updateInner(dt)

	-- End turn
	if self.state == "done" and self.endTurnTimer < 0 then
		self:nextTurn()
	end

	self.ai:update()

	local enemies = 0
	local allies = 0
	for _, entity in ipairs(self.entities) do
		---@cast entity WormEntity
		if entity:instanceOf(Classes.worm) then
			if entity.enemy then
				enemies = enemies + 1
			else
				allies = allies + 1
			end
		end
	end

	if enemies == 0 and allies > 0 then
		love.filesystem.write(tostring(self.level.path), "true")
		SwitchState(Classes.menu())
	elseif enemies == 0 and allies == 0 then
		SwitchState(Classes.menu())
	elseif enemies > 0 and allies == 0 then
		SwitchState(Classes.menu())
	end
end

function Classes.game:updateInner(dt)
	local e = self:getCurrentEntity()
	self.turnTimer = self.turnTimer + dt

	-- Update world
	local active = self.level:update(dt)

	if self.state == "aim" then
		if self.weapon and self.weapon.power then
			self.power = math.abs(love.timer.getTime() % 2 - 1)
		else
			self.power = 1
		end
	end

	-- End movement phase
	if self.state == "move" then
		local distance = math.sqrt((self.startX - e.x) ^ 2 + (self.startY - e.y) ^ 2)
		self.power = 1 - distance / self.maxDistance

		if self.power < 0 then
			self.power = 0
			self.state = "idle"
		end
	end

	-- Update weapon
	if self.weapon then
		active = self.weapon:update(dt) or active
	end

	-- Update entities
	for _, entity in ipairs(self.entities) do
		active = entity:update(dt) or active
	end
	for i = #self.entities, 1, -1 do
		if self.entities[i].dead then
			table.remove(self.entities, i)
		end
	end

	-- End turn
	if self.state == "done" then
		self.endTurnTimer = self.endTurnTimer - (active and 0.1 or 1) * dt

		if self.endTurnTimer < 0 then
			self.turn = self.turn + 1
		end
	end
end

function Classes.game:isActionKey(key)
	return key == "x" or key == "return"
end

function Classes.game:isStartKey(key)
	return key == "space" or key == "escape"
end

function Classes.game:aim()
	local res = self:getCurrentResources()
	if not self.weapon.paid then
		if res.weapons[self.weapon.name] > 0 then
			res.weapons[self.weapon.name] = res.weapons[self.weapon.name] - 1
		else
			res.berries = res.berries - self.weapon.berries
			res.wood = res.wood - self.weapon.wood
			res.crystals = res.crystals - self.weapon.crystals
		end
		self.weapon.paid = true
	end
	self.state = "aim"
	self.weapon:aim()
end

function Classes.game:trigger()
	self.state = "done"
	self.weapon:trigger()
end

function Classes.game:keypressed(key)
	if self.inventoryOpen then
		self.inventory:keypressed(key)
	else
		if (self:isStartKey(key) or self:isActionKey(key) and not self.weapon) and not self.inventoryOpen and (self.state == "move" or self.state == "idle") and (self.humanPlayerTwo or self.isPlayerTurn) then
			self.inventoryOpen = true
		elseif self:isActionKey(key) then
			if self.weapon then
				if self.state == "move" or self.state == "idle" then
					self:aim()
				elseif self.state == "aim" then
					self:trigger()
				end
			end
		end
	end
end

---Creates an explosion, damaging blocks and entities while creating particles
---@param x number
---@param y number
---@param range number
---@param blockDamage number
---@param entityDamage number | nil
---@param knockback number | nil
function Classes.game:explosion(x, y, range, blockDamage, entityDamage, knockback)
	for px = math.floor(x - range), math.ceil(x + range) do
		for py = math.floor(y - range), math.ceil(y + range) do
			local distance = math.sqrt((px - x) ^ 2 + (py - y) ^ 2)
			if distance < range then
				local damage = 1 + (1 - distance / range) * blockDamage - math.random() * 0.25
				local block = self.level:getBlock(px, py)
				if damage > block.health then
					self.level:setBlock(px, py, Blocks.AIR)
				end
			end
		end
	end

	self:bang(x, y, range, entityDamage or blockDamage * 5, knockback or blockDamage * 10)

	PlaySound("explosion")
end

---Creates an explosion, damaging blocks and entities while creating particles
---@param x number
---@param y number
---@param range number
---@param entityDamage number
---@param knockback number
function Classes.game:bang(x, y, range, entityDamage, knockback)
	for _, entity in ipairs(self.entities) do
		local distance = entity:getDistance(x, y)
		if distance < range and entity:instanceOf(Classes.worm) then
			local damage = (1 - distance / range) * (entityDamage or 5)
			---@cast entity WormEntity
			entity:hurt(damage)

			local vx = entity.x - x
			local vy = entity.y - y - 1
			local d = math.sqrt(vx ^ 2 + vy ^ 2)
			local s = (knockback or 10) / d * (1 - distance / range)
			entity.vx = entity.vx + vx * s
			entity.vy = entity.vy + vy * s
		end
	end
end

---Mines an area and connected stuff, returning the items mined
---@param x number
---@param y number
---@param range number
---@param extraRange number
---@return integer berries
---@return integer wood
---@return integer crystals
function Classes.game:mine(x, y, range, extraRange)
	local todo = {}
	for px = math.floor(x - range), math.ceil(x + range) do
		for py = math.floor(y - range), math.ceil(y + range) do
			local distance = math.sqrt((px - x) ^ 2 + (py - y) ^ 2)
			if distance < range then
				table.insert(todo, { px, py, true })
			end
		end
	end

	local berries, wood, crystals = 0, 0, 0

	while extraRange > 0 and #todo > 0 do
		local bx, by, free = unpack(table.remove(todo, 1))
		local b = self.level:getBlock(bx, by)
		if b.minable then
			for rx = -1, 1 do
				for ry = -1, 1 do
					table.insert(todo, { bx + rx, by + ry, false })
				end
			end

			berries = berries + b.berries
			wood = wood + b.wood
			crystals = crystals + b.crystals

			if not free then
				extraRange = extraRange - 1
			end
		end

		if b ~= Blocks.AIR then
			self.level:setBlock(bx, by, Blocks.AIR)
		end
	end

	berries = math.floor(berries / 5)
	wood = math.floor(wood / 4)
	crystals = math.floor(crystals / 4)

	return berries, wood, crystals
end

---Mines an area and connected stuff, returning the items mined
---@param x number
---@param y number
---@param range number
---@param extraRange number
function Classes.game:mineAndCollect(x, y, range, extraRange)
	local berries, wood, crystals = self:mine(x, y, range, extraRange)
	local res = self:getCurrentResources()

	if berries > 0 or wood > 0 or crystals > 0 then
		PlaySound("pickup")
		res.berries = res.berries + berries
		res.wood = res.wood + wood
		res.crystals = res.crystals + crystals
	end
end

function Classes.game:clone()
	local c = DeepCopy(self)
	c.level = self.level:clone()
	return setmetatable(c, getmetatable(self))
end

function Classes.game:getScore()
	local score = 0

	for _, entity in ipairs(self.entities) do
		---@cast entity WormEntity
		if entity:instanceOf(Classes.worm) then
			score = score + entity.health * (entity.enemy and 1 or -1)
		end
	end

	score = score - self.resourcesA.berries * 0.2
	score = score - self.resourcesA.berries * 0.6
	score = score - self.resourcesA.crystals * 1.0

	score = score + self.resourcesB.berries * 0.2
	score = score + self.resourcesB.berries * 0.6
	score = score + self.resourcesB.crystals * 1.0

	for _, count in pairs(self.resourcesA.weapons) do
		score = score - 0.1 * count
	end

	for _, count in pairs(self.resourcesB.weapons) do
		score = score + 0.1 * count
	end

	return score
end
