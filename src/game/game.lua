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

	self.inventoryOpen = false
	self.inventory = Classes.inventory()
end

function Classes.game:getCurrentEntity()
	return self.isPlayerTurn and self.currentPlayer or self.currentEnemy
end

function Classes.game:addEntity(entity)
	self.lastEntityID = self.lastEntityID + 1
	entity.index = self.lastEntityID
	table.insert(self.entities, entity)
end

function Classes.game:nextTurn()
	self.isPlayerTurn = not self.isPlayerTurn

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
	end
end

function Classes.game:update(dt)
	self:getCurrentEntity():control(
		love.keyboard.isDown("left", "a"),
		love.keyboard.isDown("right", "d"),
		love.keyboard.isDown("up", "w"),
		love.keyboard.isDown("down", "s")
	)

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
		elseif self.inventoryOpen and (key == "space" or key == "escape" or key == "return") then
			self.inventoryOpen = false
		end
	end
end
