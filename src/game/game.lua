---@class GameState : State
Classes.game = Clazz()

require("src.game.blocks")
require("src.game.level")
require("src.game.inventory")
require("src.game.weapons")

require("src.game.entities.entity")
require("src.game.entities.worm")

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

	self:nextTurn()

	self.state = "move"
	self.power = 1
	self.maxDistance = 20

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

		if self.state == "weapon" then
			self.weapon:draw()
		end
	end
end

function Classes.game:update(dt)
	if self.state == "move" then
		local e = self:getCurrentEntity()
		e:control(
			love.keyboard.isDown("left", "a"),
			love.keyboard.isDown("right", "d"),
			love.keyboard.isDown("up", "w"),
			love.keyboard.isDown("down", "s")
		)

		local distance = math.sqrt((self.startX - e.x) ^ 2 + (self.startY - e.y) ^ 2)
		self.power = distance / self.maxDistance

		if self.power > 1 then
			self.power = 1
			self.state = "idle"
		end
	end

	if self.state == "weapon" then
		self.weapon:update(dt)
	end

	for i = #self.entities, 1, -1 do
		local remove = self.entities[i]:update(dt)
		if remove then
			table.remove(self.entities, i)
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
			if self.state ~= "weapon" and self.weapon then
				self.state = "weapon"
				self.weapon:trigger()
			end
		end
	end
end
