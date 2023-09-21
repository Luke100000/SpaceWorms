---@class Level
Classes.level = Clazz()

Classes.level.width = 160
Classes.level.height = 120


---Initializes a new game
---@param level number
function Classes.level:init(level)
	local data = require("data.levels." .. level)

	local image = love.image.newImageData("data/levels/" .. level .. ".png")

	self.spawns = {
		a = {},
		b = {}
	}

	self.imageData = love.image.newImageData(self.width, self.height)
	self.image = love.graphics.newImage(self.imageData)

	self.dirty = false

	self.world = {}
	for x = 1, Classes.level.width do
		self.world[x] = {}
		for y = 1, Classes.level.height do
			local r, g, b = image:getPixel(x - 1, y - 1)
			local block = Blocks.fromColor(r, g, b)
			if block == Blocks.SPAWN_A then
				table.insert(self.spawns.a, { x, y })
				block = Blocks.AIR
			elseif block == Blocks.SPAWN_B then
				table.insert(self.spawns.b, { x, y })
				block = Blocks.AIR
			end
			self:setPixel(x, y, block)
		end
	end
end

---Sets a pixel
---@param x integer
---@param y integer
---@param block Block
function Classes.level:setPixel(x, y, block)
	self.world[x][y] = block
	local p = Blocks.getIndex(block) / 3
	self.imageData:setPixel(x - 1, y - 1, p, p, p, 1.0)
	self.dirty = true
end

---Gets a pixel
---@param x integer
---@param y integer
---@returns Block
function Classes.level:getPixel(x, y)
	return self.world[x][y]
end

function Classes.level:getImage()
	if self.dirty then
		self.dirty = false
		self.image:replacePixels(self.imageData, 0, 1, 0, 0, false)
	end
	return self.image
end
