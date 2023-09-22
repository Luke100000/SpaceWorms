---@class ShotgunWeapon : Weapon
local class = require("src.game.weapons.weapon"):extend()

class.x = 1
class.y = 1

class.description = "A shotgun"

---@param game GameState
function class:init(game)
	class.super.init(self, game)

	self.angle = math.pi / 2
end

function class:draw()
	local e = self.game:getCurrentEntity()
	local dx = math.cos(self.angle)
	local dy = math.sin(self.angle)
	if not e.right then
		dx = -dx
	end
	love.graphics.line(e.x, e.y, e.x + dx * 10, e.y + dy * 10)
end

function class:trigger()

end

---@param dt number
function class:update(dt)
	
end

return class
