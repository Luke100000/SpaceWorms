---@class ShotgunWeapon : Weapon
local class = require("src.game.weapons.weapon"):extend()

class.x = 2
class.y = 1

class.description = "A shotgun"

---@param game GameState
function class:init(game)
	class.super.init(self, game)
end

function class:draw()
	local e = self.game:getCurrentEntity()
	local dx = math.cos(e.aim)
	local dy = math.sin(e.aim)
	if not e.right then
		dx = -dx
	end

	love.graphics.setColor(0.5, 0.5, 0.5)
	love.graphics.line(e:getCenterX(), e:getCenterY() - 2, e.x + dx * 10, e.y + dy * 10)
	love.graphics.setColor(1, 1, 1)
end

function class:trigger()
	local e = self.game:getCurrentEntity()
	local dx = math.cos(e.aim)
	local dy = math.sin(e.aim)
	if not e.right then
		dx = -dx
	end

	local strength = self.game.power * 50

	self.game:addEntity(Classes.bullet(self.game, e, e:getCenterX(), e:getCenterY() - 2, dx * strength, dy * strength))
end

---@param dt number
function class:update(dt)

end

return class
