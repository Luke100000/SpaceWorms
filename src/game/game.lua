---@class GameState : State
Classes.game = Clazz()

require("src.game.blocks")
require("src.game.level")

---Initializes a new game
---@param level number
---@param humanPlayerTwo boolean
function Classes.game:init(level, humanPlayerTwo)
	---@type Level
	self.level = Classes.level(level)

	self.humanPlayerTwo = humanPlayerTwo
end

function Classes.game:draw()
	love.graphics.draw(self.level:getImage())

	love.graphics.print("This is an example text\njust to see how it would look like.")
end

function Classes.game:update(dt)

end

function Classes.game:keypressed(key)

end
