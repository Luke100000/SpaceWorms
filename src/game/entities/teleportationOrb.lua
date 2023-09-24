---@class TeleportationOrbEntity : BulletEntity
local class = require("src.game.entities.bullet"):extend()

class.width = 2
class.height = 2

function class:explode()
	local e = self.game:getCurrentEntity()
	for attempt = 1, 100 do
		e.x = math.floor(self.x + (math.random() - 0.5) * math.sqrt(attempt - 1))
		e.y = math.floor(self.y + (math.random() - 0.5) * math.sqrt(attempt - 1))
		if not e:collides().collided then
			break
		end
	end
end

return class
