---@class Entity : Clazz
Classes.entity = Clazz()

Classes.entity.width = 1
Classes.entity.height = 1

function Classes.entity:init()
	self.x = 0
	self.y = 0

	self.dead = false
end

function Classes.entity:draw()

end

function Classes.entity:update(dt)

end

function Classes.entity:control(left, right, up, down)

end

function Classes.entity:touches(entity)
	return self.x + self.width > entity.x
		and self.x < entity.x + entity.width
		and self.y + self.height > entity.y
		and self.y < entity.y + entity.height
end

function Classes.entity:getCenterX()
	return self.x + self.width / 2
end

function Classes.entity:getCenterY()
	return self.y + self.height / 2
end

---Returns the distance
---@param x number
---@param y number
---@return number
function Classes.entity:getDistance(x, y)
	return math.sqrt((self:getCenterX() - x) ^ 2 + (self:getCenterY() - y) ^ 2)
end
