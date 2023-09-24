---@class BridgeWeapon : AimingWeapon
local class = require("src.game.weapons.aimingWeapon"):extend()

class.x = 2
class.y = 3

class.crosshair = Texture.crosshair.building

class.icon = Texture.weapon.bridge
class.description = "A sturdy wooden bridge to cross holes safely."

class.power = false
class.minStrength = 1
class.maxStrength = 1

class.berries = 0
class.wood = 2
class.crystals = 0

---Fire with given origin and direction
---@param e WormEntity
---@param ox number
---@param oy number
---@param dx number
---@param dy number
function class:fire(e, ox, oy, dx, dy)
	for i = 1, 9 do
		for x = 1, 2 do
			for y = 1, 2 do
				local px = math.floor(ox + x + (dx > 0 and 1 or -1) * i * 3)
				local py = math.floor(oy + y + dy * i * 3 + 3)
				local b = self.game.level:getBlock(px, py)
				if b == Blocks.AIR then
					self.game.level:setBlock(px, py, Blocks.WOOD)
				end
			end
		end
	end
end

return class
