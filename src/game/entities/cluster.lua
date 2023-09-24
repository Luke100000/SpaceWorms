---@class ClusterEntity : GrenadeEntity
local class = require("src.game.entities.grenade"):extend()

class.range = 5
class.power = 0.2
class.explodeOnImpact = false

function class:explode()
	---@diagnostic disable-next-line: undefined-field
	class.super.explode(self)

	for i = 1, 5 do
		self.game:addEntity(require("src.game.entities.bullet")(self.game, self.source, self.x, self.y,
			(math.random() - 0.5) * 5, -10))
	end
end

return class
