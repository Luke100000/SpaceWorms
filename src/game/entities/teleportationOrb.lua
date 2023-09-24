---@class TeleportationOrbEntity : BulletEntity
local class = require("src.game.entities.bullet"):extend()

class.width = 2
class.height = 2

function class:explode()
	local cx = math.ceil(self:getCenterX())
	local cy = math.ceil(self:getCenterY())
	local range = 12
	for x = -range, range do
		for y = -range, range do
			local d = math.sqrt(x ^ 2 + y ^ 2)
			if d < range then
				local b = self.game.level:getBlock(cx + x, cy + y)
				if b == Blocks.AIR then
					self.game.level:setBlock(cx + x, cy + y, Blocks.LAVA)
				end
			end
		end
	end
end

return class