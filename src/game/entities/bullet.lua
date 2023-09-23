---@class BulletEntity : Entity
Classes.bullet = Classes.entity:extend()

---@param game GameState
---@param source Entity
---@param x number
---@param y number
---@param vx number
---@param vy number
function Classes.bullet:init(game, source, x, y, vx, vy)
	self.game = game

	self.source = source

	self.x = x
	self.y = y

	self.vx = vx
	self.vy = vy
end

function Classes.bullet:draw()
	love.graphics.rectangle("fill", self.x, self.y, 1, 1)
end

function Classes.bullet:collides()
	return self.game.level:checkCollision(math.floor(self.x - 0.5), math.floor(self.y - 0.5), 1, 1)
end

function Classes.bullet:collidesWithEntity()
	for i, entity in ipairs(self.game.entities) do
		if entity ~= self and entity ~= self.source and entity:touches(self) then
			return true
		end
	end
	return false
end

function Classes.bullet:update(dt)
	self.x = self.x + self.vx * dt
	self.y = self.y + self.vy * dt

	self.vy = self.vy + 10 * dt

	if self:collides() or self:collidesWithEntity() then
		self.dead = true

		self.game:explosion(self.x, self.y, 16, 1.0)
	end
end
