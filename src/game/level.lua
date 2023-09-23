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
	self.timer = 0

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
		self.imageData:setPixel(x - 1, y - 1, block.texture[1], block.texture[2], block.texture[3], block.texture[4])
		self.dirty = true
	end
end

---Gets a pixel
---@param x integer
---@param y integer
---@returns Block
function Classes.level:getBlock(x, y)
	return self:isValid(x, y) and self.world[x][y] or
		(y < 0 and x > 0 and x <= self.width and Blocks.AIR or Blocks.STONE)
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

---Attempts to move a block
---@private
---@param x integer
---@param y integer
---@param tx integer
---@param ty integer
---@param b Block
---@return boolean
function Classes.level:attemptMovement(x, y, tx, ty, b)
	local tb = self:getBlock(tx, ty)
	if b == Blocks.WATER then
		if tb == Blocks.AIR then
			self:setBlock(x, y, Blocks.AIR)
			self:setBlock(tx, ty, Blocks.WATER)
			return true
		elseif tb == Blocks.LAVA then
			self:setBlock(x, y, Blocks.AIR)
			self:setBlock(tx, ty, Blocks.STONE)
			return true
		end
	elseif b == Blocks.LAVA then
		if tb == Blocks.AIR then
			self:setBlock(x, y, Blocks.AIR)
			self:setBlock(tx, ty, Blocks.LAVA)
			return true
		elseif tb == Blocks.WATER then
			self:setBlock(x, y, Blocks.AIR)
			self:setBlock(tx, ty, Blocks.STONE)
			return true
		end
	end
	return false
end

function Classes.level:update(dt)
	local actions = 0

	local tickRate = 10

	self.timer = self.timer + dt
	if self.timer > 1 / tickRate then
		self.timer = self.timer - 1 / tickRate
		if self.timer > 10 then
			self.timer = 0
		end

		for x = 1, self.width do
			for y = 1, self.height do
				local b = self:getBlock(x, y)
				if b == Blocks.WATER then
					local offset = math.random() < 0.5 and 1 or -1
					if self:attemptMovement(x, y, x, y + 1, b)
						or self:attemptMovement(x, y, x + offset, y + 1, b)
						or self:attemptMovement(x, y, x - offset, y + 1, b)
						or self:attemptMovement(x, y, x - offset, y, b)
						or self:attemptMovement(x, y, x - offset, y, b) then
						actions = actions + 1
					end
				end
				if b == Blocks.LAVA then
					local offset = math.random() < 0.5 and 1 or -1
					if self:attemptMovement(x, y, x, y + 1, b)
						or self:attemptMovement(x, y, x + offset, y + 1, b)
						or self:attemptMovement(x, y, x - offset, y + 1, b) then
						actions = actions + 1
					end
				end
			end
		end
	end

	return actions > 1
end
