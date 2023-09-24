---@class GrenadeWeapon : AimingWeapon
local class = require("src.game.weapons.aimingWeapon"):extend()

class.x = 6
class.y = 1

class.crosshair = Texture.weapon.grenade

class.icon = Texture.weapon.grenade
class.description = "A grenade, bounces of walls but explodes on contact with worms."

---Fire with given origin and direction
---@param e WormEntity
---@param ox number
---@param oy number
---@param dx number
---@param dy number
function class:fire(e, ox, oy, dx, dy)
	self.game:addEntity(require("src.game.entities.bullet")(self.game, e, ox, oy, dx, dy))
end

return class
