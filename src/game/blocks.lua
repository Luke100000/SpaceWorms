---@class Block
Block = Clazz()

function Block:init(texture, collision, health)
	self.texture = texture
	self.collision = collision
	self.health = health
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
	colorToBlock[colorToId(r, g, b)] = block
	return block
end

---@type {[string] : Block}
Blocks = {
	AIR = register(Block({ 0, 0, 0, 0 }, 0, 0), 0, 0, 0),
	STONE = register(Block({ 1.0, 0, 0, 1 }, 2, 1), 255, 255, 255),
	WATER = register(Block({ 1.0, 1.0, 0, 1 }, 2, 1), 0, 255, 255),
	SPAWN_A = register(Block({ 0, 0, 0, 1 }, 0, 0), 0, 255, 0),
	SPAWN_B = register(Block({ 0, 0, 0, 1 }, 0, 0), 255, 0, 0)
}
