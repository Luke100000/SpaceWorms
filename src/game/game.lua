---@class GameState : State
Classes.game = Clazz()

require("src.game.blocks")
require("src.game.level")
require("src.game.inventory")
require("src.game.weapons")

require("src.game.entities.entity")
require("src.game.entities.worm")
require("src.game.entities.bullet")

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
	for _, pos in ipairs(self.level.spawns.a) do
		self:addEntity(Classes.worm(self, false, pos[1], pos[2]))
	end
	for _, pos in ipairs(self.level.spawns.b) do
		self:addEntity(Classes.worm(self, true, pos[1], pos[2]))
	end

	self.currentPlayer = false
	self.currentEnemy = false
	self.isPlayerTurn = true

	self.state = "move"
	self.power = 1
	self.maxDistance = 20

	self.endTurnTimer = 1

	self:nextTurn()

	self.inventoryOpen = false

	---@type Inventory
	self.inventory = Classes.inventory(self)

	---@type Weapon
	self.weapon = nil
end

---Returns the current entity
---@return WormEntity
function Classes.game:getCurrentEntity()
	---@diagnostic disable-next-line: return-type-mismatch
	return self.isPlayerTurn and self.currentPlayer or self.currentEnemy
end

function Classes.game:addEntity(entity)
	self.lastEntityID = self.lastEntityID + 1
	entity.index = self.lastEntityID
	table.insert(self.entities, entity)
end

function Classes.game:nextTurn()
	self.isPlayerTurn = not self.isPlayerTurn

	self:nextEntity()

	local e = self:getCurrentEntity()
	self.startX = e.x
	self.startY = e.y

	self.endTurnTimer = 1
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
	if self.inventoryOpen then
		self.inventory:draw()
	else
		love.graphics.draw(self.level:getImage())

		for _, entity in ipairs(self.entities) do
			entity:draw()
		end

		love.graphics.draw(Texture.ingameMenu)

		love.graphics.rectangle("fill", 110, 130, (1 - self.power) * 20, 8)

		if self.state == "aim" then
			self.weapon:draw()
		end
	end
end

function Classes.game:update(dt)
	-- Control entity
	local e = self:getCurrentEntity()
	e:control(
		love.keyboard.isDown("left", "a"),
		love.keyboard.isDown("right", "d"),
		love.keyboard.isDown("up", "w"),
		love.keyboard.isDown("down", "s")
	)

	local active = false

	-- End movement phase
	if self.state == "move" then
		local distance = math.sqrt((self.startX - e.x) ^ 2 + (self.startY - e.y) ^ 2)
		self.power = distance / self.maxDistance

		if self.power > 1 then
			self.power = 1
			self.state = "idle"
		end
	end

	-- Update weapon
	if self.state == "aim" or self.state == "done" then
		self.weapon:update(dt)
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
			self:nextTurn()
		end
	end
end

function Classes.game:keypressed(key)
	if self.inventoryOpen then
		self.inventory:keypressed(key)
	else
		if key == "space" and not self.inventoryOpen then
			self.inventoryOpen = true
		elseif key == "x" or key == "return" then
			if self.weapon then
				if self.state ~= "aim" then
					self.state = "aim"
					self.weapon:aim()
				elseif self.state == "aim" then
					self.state = "done"
					self.weapon:trigger()
				end
			end
		end
	end
end

---Creates an explosion, damaging blocks and entities while creating particles
---@param x number
---@param y number
---@param range number
---@param strength number
function Classes.game:explosion(x, y, range, strength)
	for px = math.floor(x - range), math.ceil(x + range) do
		for py = math.floor(y - range), math.ceil(y + range) do
			local distance = math.sqrt((px - x) ^ 2 + (py - y) ^ 2)
			if distance < range then
				local damage = 1 + distance / range * strength - math.random() * 0.25
				local block = self.level:getBlock(px, py)
				if damage > block.health then
					self.level:setBlock(px, py, Blocks.AIR)
				end
			end
		end
	end

	for _, entity in ipairs(self.entities) do
		local distance = entity:getDistance(x, y)
		if distance < range and entity:instanceOf(Classes.worm) then
			local damage = (distance / range * strength - math.random()) * 5
			---@cast entity WormEntity
			entity:hurt(range)
		end
	end
end
