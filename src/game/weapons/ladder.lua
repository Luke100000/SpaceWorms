---@class BridgeWeapon : Weapon
local class = require("src.game.weapons.weapon"):extend()

class.x = 1
class.y = 3

class.crosshair = Texture.crosshair.building

class.icon = Texture.weapon.bridge
class.description = "Build a makeshift ladder."

function class:aim()
	local e = self.game:getCurrentEntity()
	for i = 1, 6 do
		for x = 1, 4 do
			for y = 1, 1 do
				local px = math.floor(e:getCenterX()) + x - 2
				local py = math.floor(e:getCenterY()) - i * 3 + y
				local b = self.game.level:getBlock(px, py)
				if b == Blocks.AIR then
					self.game.level:setBlock(px, py, Blocks.WOOD)
				end
			end
		end
	end

	self.game.state = "done"
end

return class
