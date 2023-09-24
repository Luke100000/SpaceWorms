---@class Entity : Clazz
local class = Clazz()

class.width = 1
class.height = 1

---@param game GameState
function class:init(game)
	self.game = game
	
	self.x = 0
	self.y = 0

	self.dead = false
end

function class:draw()

end

function class:update(dt)

end

function class:nextTurn()

end

function class:control(left, right, up, down)

end

function class:collides()
	return self.game.level:checkCollision(math.ceil(self.x), math.ceil(self.y), self.width, self.height)
end

function class:touches(entity)
	return self.x + self.width > entity.x
		and self.x < entity.x + entity.width
		and self.y + self.height > entity.y
		and self.y < entity.y + entity.height
end

function class:getCenterX()
	return self.x + self.width / 2
end

function class:getCenterY()
	return self.y + self.height / 2
end

---Returns the distance
---@param x number
---@param y number
---@return number
function class:getDistance(x, y)
	return math.sqrt((self:getCenterX() - x) ^ 2 + (self:getCenterY() - y) ^ 2)
end

return class