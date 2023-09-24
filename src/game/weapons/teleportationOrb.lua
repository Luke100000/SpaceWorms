---@class TeleportationOrb : AimingWeapon
local class = require("src.game.weapons.aimingWeapon"):extend()

class.x = 2
class.y = 2

class.crosshair = Texture.crosshair.orb

class.icon = Texture.weapon.teleportationOrb
class.description = "The teleportation orb transports you to the impact location."

class.minStrength = 10
class.maxStrength = 100

class.berries = 3
class.wood = 0
class.crystals = 0

---Fire with given origin and direction
---@param e WormEntity
---@param ox number
---@param oy number
---@param dx number
---@param dy number
function class:fire(e, ox, oy, dx, dy)
	self.game:addEntity(require("src.game.entities.teleportationOrb")(self.game, e, ox, oy, dx, dy))
end

return class
