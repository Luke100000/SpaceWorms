---@class BulletEntity : Entity
local class = require("src.game.entities.entity"):extend()

class.bounciness = 0.0

class.range = 5
class.power = 1
class.explodeOnImpact = true

class.width = 1
class.height = 1

---@param game GameState
---@param source Entity
---@param x number
---@param y number
---@param vx number
---@param vy number
function class:init(game, source, x, y, vx, vy)
	class.super.init(self, game)

	self.source = source

	self.x = x - self.width / 2
	self.y = y - self.height / 2

	self.vx = vx
	self.vy = vy

	self.timer = 1
end

function class:draw()
	love.graphics.setColor(0.7, 0.7, 0.7)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(1, 1, 1)
end

function class:collidesWithEntity()
	for i, entity in ipairs(self.game.entities) do
		---@diagnostic disable-next-line: undefined-field
		if entity ~= self and entity ~= self.source and entity.enemy ~= self.source.enemy and entity:touches(self) then
			return true
		end
	end
	return false
end

function class:update(dt)
	self.x = self.x + self.vx * dt
	self.y = self.y + self.vy * dt

	local speed = math.sqrt(self.vx ^ 2 + self.vy ^ 2)
	self.timer = self.timer - (speed < 3.0 and dt or dt * 0.05)
	if self.timer < 0 then
		self.dead = true
		self:explode()
		return true
	end

	self.vy = self.vy + 10 * dt

	local oldX = self.x
	local oldY = self.y
	local flags = self:collides()
	if flags.collided then
		if self.bounciness > 0 then
			local nx, ny = self.game.level:getGradient(math.ceil(self:getCenterX()), math.ceil(self:getCenterY()))
			if nx ~= 0 or ny ~= 0 then
				local dot = 2 * (self.vx * nx + self.vy * ny)
				self.vx = (self.vx - dot * nx) * self.bounciness
				self.vy = (self.vy - dot * ny) * self.bounciness
			else
				self.vx = -self.vx
				self.vy = -self.vy
			end
			self.x = oldX
			self.y = oldY
		else
			self.dead = true
			self:explode()
			return true
		end
	end

	-- damping
	self.vx = self.vx * (1 - flags.damping * dt)
	self.vy = self.vy * (1 - flags.damping * dt)

	if self.explodeOnImpact and self:collidesWithEntity() then
		self.dead = true
		self:explode()
		return true
	end

	return true
end

function class:explode()
	self.game:explosion(self:getCenterX(), self:getCenterY(), self.range, self.power)
end

return class