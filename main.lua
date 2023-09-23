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

local canvas = love.graphics.newCanvas(Globals.width, Globals.height)

function love.draw()
	-- render
	love.graphics.setCanvas(canvas)
	state:draw()
	love.graphics.setCanvas()

	-- draw cannvas
	local w, h = love.graphics.getDimensions()
	local scale = math.max(1, math.floor(math.min(w / Globals.width, h / Globals.height)))
	love.graphics.origin()
	love.graphics.push("all")
	love.graphics.setShader(MainShader)
	love.graphics.draw(canvas, (w - Globals.width * scale) / 2, (h - Globals.height * scale) / 2, 0, scale)
	love.graphics.pop()
end

function love.update(dt)
	state:update(dt)
end

function love.keypressed(key)
	state:keypressed(key)
end
