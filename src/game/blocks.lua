---@class Block
Block = Clazz()

function Block:init(texture, collision, health, flags)
	self.texture = texture
	self.collision = collision
	self.health = health

	self.damping = flags.damping or 0.0
	self.damage = flags.damage or 0.0
	self.instantDamage = flags.instantDamage or 0.0

	self.minable = flags.berries or flags.wood or flags.crystals
	self.berries = flags.berries or 0
	self.wood = flags.wood or 0
	self.crystals = flags.crystals or 0
end

---@type table { [integer]: Block }
local colorToBlock = {}

---Converts a float RGB color to an integer id
---@param r number
---@param g number
---@param b number
---@return integer
local function colorToId(r, g, b)
	local br, bg, bb = love.math.colorToBytes(r, g, b)
	return br * 256 ^ 2 + bg * 256 + bb
end

---Converts a float RGB color to a block
---@param r number
---@param g number
---@param b number
---@return Block
function Block.fromColor(r, g, b)
	return colorToBlock[colorToId(r, g, b)]
end

---Registers a new block
---@param r integer
---@param g integer
---@param b integer
---@return Block
local function register(block, r, g, b)
	local id = r * 256 ^ 2 + g * 256 + b
	colorToBlock[id] = block
	return block
end

---@type {[string] : Block}
Blocks = {
	AIR = register(Block({ 0, 0, 0, 0 }, 0, 0, {}), 0, 0, 0),
	STONE = register(Block({ 1.0, 0, 0, 1 }, 2, 1, {}), 255, 255, 255),
	WOOD = register(Block({ 0.25, 0, 0, 1 }, 1, 0.5, { wood = 1 }), 255, 136, 0),

	LAVA = register(Block({ 0.0, 0, 1.0, 1 }, 0, 1, { damage = 2, instantDamage = 2, damping = 0.9 }), 255, 0, 0),
	WATER = register(Block({ 0.0, 1.0, 0, 1 }, 0, 1, { damping = 0.25 }), 0, 148, 255),

	CRYSTAL = register(Block({ 0, 1.0, 1.0, 1 }, 2, 1, { crystals = 1 }), 0, 255, 255),

	PLANT_0 = register(Block({ 0.3, 0, 0, 1 }, 0, 0.25, { berries = 1 }), 127, 0, 55),
	PLANT_1 = register(Block({ 0.6, 0, 0, 1 }, 0, 0.25, { berries = 1 }), 255, 0, 110),
	PLANT_2 = register(Block({ 1.0, 0, 0, 1 }, 0, 0.25, { berries = 1 }), 255, 0, 220),

	SPAWN_A_SINGLEPLAYER = register(Block({ 0, 0, 0, 1 }, 0, 0, {}), 255, 216, 0),
	SPAWN_B_SINGLEPLAYER = register(Block({ 0, 0, 0, 1 }, 0, 0, {}), 127, 106, 0),
	SPAWN_A_MULTIPLAYER = register(Block({ 0, 0, 0, 1 }, 0, 0, {}), 255, 178, 127),
	SPAWN_B_MULTIPLAYER = register(Block({ 0, 0, 0, 1 }, 0, 0, {}), 255, 127, 127)
}
