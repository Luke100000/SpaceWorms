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
			local block = Block.fromColor(r, g, b)
			if block == Blocks.SPAWN_A then
				table.insert(self.spawns.a, { x, y })
				block = Blocks.AIR
			elseif block == Blocks.SPAWN_B then
				table.insert(self.spawns.b, { x, y })
				block = Blocks.AIR
			end
			self:setBlock(x, y, block)
		end
	end
end

---Sets a pixel
---@param x integer
---@param y integer
---@param block Block
function Classes.level:setBlock(x, y, block)
	if self:isValid(x, y) then
		self.world[x][y] = block
		local p = block.texture / 3
		self.imageData:setPixel(x - 1, y - 1, p, p, p, 1.0)
		self.dirty = true
	end
end

---Gets a pixel
---@param x integer
---@param y integer
---@returns Block
function Classes.level:getBlock(x, y)
	return self:isValid(x, y) and self.world[x][y] or (y < 0 and x > 0 and x <= self.width and Blocks.AIR or Blocks.STONE)
end

---Checks if a pixel is within map
---@param x integer
---@param y integer
function Classes.level:isValid(x, y)
	return x > 0 and y > 0 and x <= self.width and y <= self.height
end

---Updates and returns the map texture
---@return love.Image
function Classes.level:getImage()
	if self.dirty then
		self.dirty = false
		self.image:replacePixels(self.imageData, 0, 1, 0, 0, false)
	end
	return self.image
end

---Check for collision
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@return boolean
function Classes.level:checkCollision(x, y, w, h)
	for px = x, x + w - 1 do
		for py = y, y + h - 1 do
			if self:getBlock(px, py).collision >= 2 then
				return true
			end
		end
	end
	return false
end
