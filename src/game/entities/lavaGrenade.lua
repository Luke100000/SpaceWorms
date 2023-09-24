---@class LavaGrenade : GrenadeEntity
Classes.lavaGrenade = Classes.grenade:extend()

function Classes.lavaGrenade:explode()
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
