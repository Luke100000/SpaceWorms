---@class ClusterGrenadeEntity : GrenadeEntity
local class = require("src.game.entities.grenade"):extend()

class.range = 9
class.power = 0.8

function class:explode()
	---@diagnostic disable-next-line: undefined-field
	class.super.explode(self)

	for i = 1, 5 do
		self.game:addEntity(require("src.game.entities.cluster")(self.game, self.source, self.x, self.y,
			(math.random() - 0.5) * 15, -10))
	end
end

return class
