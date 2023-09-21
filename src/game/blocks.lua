---@class Block
Block = {}

---@type table { [integer]: Block }
local colorToBlock = {}
local blockToIndex = {}

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
---@return Blocks
function Block.fromColor(r, g, b)
	return colorToBlock[colorToId(r, g, b)]
end

---Gets the color index
---@param block Blocks
---@return integer
function Block.getIndex(block)
	return blockToIndex[block]
end

local lastID = 0

---Registers a new block
---@param r integer
---@param g integer
---@param b integer
---@return Blocks
local function register(index, r, g, b)
	lastID = lastID + 1
	colorToBlock[colorToId(r, g, b)] = lastID
	blockToIndex[lastID] = index
	return lastID
end

---@enum Blocks
Blocks = {
	AIR = register(0, 0, 0, 0),
	STONE = register(3, 255, 255, 255),
	SPAWN_A = register(0, 0, 255, 0),
	SPAWN_B = register(0, 255, 0, 0)
}
