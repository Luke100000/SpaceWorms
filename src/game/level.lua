---@class Level
Classes.level = Clazz()

Classes.level.width = 160
Classes.level.height = 123


---Initializes a new game
---@param level number
function Classes.level:init(level)
	local image = love.image.newImageData("data/levels/" .. level .. ".png")

	self.path = level

	self.spawns = {
		sa = {},
		sb = {},
		ma = {},
		mb = {}
	}

	self.imageData = love.image.newImageData(self.width, self.height)
	self.image = love.graphics.newImage(self.imageData)

	self.dirty = false
	self.timer = 0

	self.particles = false

	self.world = {}
	for x = 1, Classes.level.width do
		self.world[x] = {}
		for y = 1, Classes.level.height do
			local r, g, b = image:getPixel(x - 1, y - 1)
			local block = Block.fromColor(r, g, b)
			assert(block, "Color " .. r .. " " .. g .. " " .. b .. " does not exist!")
			if block == Blocks.SPAWN_A_SINGLEPLAYER then
				table.insert(self.spawns.sa, { x, y })
				block = Blocks.AIR
			elseif block == Blocks.SPAWN_B_SINGLEPLAYER then
				table.insert(self.spawns.sb, { x, y })
				block = Blocks.AIR
			elseif block == Blocks.SPAWN_A_MULTIPLAYER then
				table.insert(self.spawns.ma, { x, y })
				block = Blocks.AIR
			elseif block == Blocks.SPAWN_B_MULTIPLAYER then
				table.insert(self.spawns.mb, { x, y })
				block = Blocks.AIR
			end
			self:setBlock(x, y, block)
		end
	end

	self.particles = {}
end

function Classes.level:clone()
	return setmetatable({
		imageData = false,
		image = false,
		dirty = false,
		timer = self.timer,
		world = DeepCopy(self.world)
	}, getmetatable(self))
end

---Sets a pixel
---@param x integer
---@param y integer
---@param block Block
function Classes.level:setBlock(x, y, block)
	if self:isValid(x, y) then
		local b = self.world[x][y]
		self.world[x][y] = block
		if self.imageData then
			self.imageData:setPixel(x - 1, y - 1, block.texture[1], block.texture[2], block.texture[3], block.texture[4])
			self.dirty = true
			if self.particles and b.collision == 2 and block == Blocks.AIR and math.random() < 0.1 then
				table.insert(self.particles, Classes.particle(x - 0.5, y - 0.5))
			end
		end
	end
end

---Gets a pixel
---@param x integer
---@param y integer
---@returns Block
function Classes.level:getBlock(x, y)
	return self:isValid(x, y) and self.world[x][y] or
		(y <= 0 and x > 0 and x <= self.width and Blocks.AIR or Blocks.STONE)
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
---@return table
function Classes.level:checkCollision(x, y, w, h)
	local flags = {
		collided = false,
		ladder = false,
		damping = 0.0,
		damage = 0.0,
		instantDamage = 0.0,
	}
	local s = 1 / (w * h)
	for px = x, x + w - 1 do
		for py = y, y + h - 1 do
			local b = self:getBlock(px, py)
			if b.collision == 2 then
				flags.collided = true
			elseif b.collision == 1 then
				flags.ladder = true
			end
			flags.damping = flags.damping + b.damping * s
			flags.damage = flags.damage * 0.75 + b.damage * 0.25
			flags.instantDamage = math.max(flags.instantDamage, b.instantDamage)
		end
	end
	return flags
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
			for y = self.height, 1, -1 do
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

	if self.particles then
		for i = #self.particles, 1, -1 do
			self.particles[i]:update(dt)
			if self.particles[i].dead then
				table.remove(self.particles, i)
			end
		end
	end

	return actions > 1
end

---Gets the gradient of the level
---@param x integer
---@param y integer
---@return number
---@return number
function Classes.level:getGradient(x, y)
	local dx, dy = 0, 0
	for rx = -2, 2 do
		for ry = -2, 2 do
			if rx ~= 0 or ry ~= 0 then
				local d = math.sqrt(rx ^ 2 + ry ^ 2)
				local b = self:getBlock(x + rx, y + ry)
				if b.collision == 2 then
					dx = dx + rx / d
					dy = dy + ry / d
				end
			end
		end
	end

	local d = math.sqrt(dx ^ 2 + dy ^ 2)
	if d > 0 then
		return dx / d, dy / d
	else
		return 0, 0
	end
end
