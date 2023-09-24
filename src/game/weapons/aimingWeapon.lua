---@class AimingWeapon : Weapon
local class = require("src.game.weapons.weapon"):extend()

class.crosshair = Texture.crosshair.shot
class.crosshairDistance = 10

class.minStrength = 5
class.maxStrength = 30

function class:draw()
	local e = self.game:getCurrentEntity()
	local dx = math.cos(e.aim)
	local dy = math.sin(e.aim)
	if not e.right then
		dx = -dx
	end

	love.graphics.draw(self.crosshair, e.x + dx * self.crosshairDistance, e.y + dy * self.crosshairDistance, 0, 1, 1,
		self.crosshair:getWidth() / 2,
		self.crosshair:getHeight() / 2)
end

function class:trigger()
	local e = self.game:getCurrentEntity()
	local dx = math.cos(e.aim)
	local dy = math.sin(e.aim)
	if not e.right then
		dx = -dx
	end

	local strength = self.game.power * (self.maxStrength - self.minStrength) + self.minStrength

	self:fire(e, e:getCenterX(), e:getCenterY() - 2, dx * strength, dy * strength)
end

---Fire with given origin and direction
---@param e WormEntity
---@param ox number
---@param oy number
---@param dx number
---@param dy number
function class:fire(e, ox, oy, dx, dy)

end

---@param dt number
function class:update(dt)

end

return class
