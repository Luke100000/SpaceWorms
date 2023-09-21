require("src.load.load")
require("src.game.game")
require("src.menu.menu")

---@class State
---@field draw fun(State)
---@field update fun(State, number)
---@field keypressed fun(State, string)

---@type State
local state

---@param s State
function SwitchState(s)
	state = s
end

SwitchState(Classes.game(1, true))

function love.draw()
	local w, h = love.graphics.getDimensions()
	local scale = math.max(1, math.floor(math.min(w / Globals.width, h / Globals.height)))
	love.graphics.translate((w - Globals.width * scale) / 2, (h - Globals.height * scale) / 2)
	love.graphics.scale(scale)

	state:draw()
end

function love.update(dt)
	state:update(dt)
end

function love.keypressed(key)
	state:keypressed(key)
end
