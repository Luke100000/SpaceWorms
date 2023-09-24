---@class TeleportationOrb : AimingWeapon
local class = require("src.game.weapons.aimingWeapon"):extend()

class.x = 2
class.y = 2

class.icon = Texture.weapon.TeleportationOrb
class.description = "The teleportation orb transports you to the impact location."

---Fire with given origin and direction
---@param e WormEntity
---@param ox number
---@param oy number
---@param dx number
---@param dy number
function class:fire(e, ox, oy, dx, dy)
	self.game:addEntity(Classes.bullet(self.game, e, ox, oy, dx, dy))
end

return class
