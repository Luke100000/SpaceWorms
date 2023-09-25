---@class ClusterGrenadeWeapon : AimingWeapon
local class = require("src.game.weapons.aimingWeapon"):extend()

class.x = 6
class.y = 2

class.bounciness = 0.5

class.crosshair = Texture.crosshair.grenade

class.icon = Texture.weapon.clusterGrenade
class.description = "Explodes into a set of smaller explosives."

class.berries = 2
class.wood = 2
class.crystals = 0

---Fire with given origin and direction
---@param e WormEntity
---@param ox number
---@param oy number
---@param dx number
---@param dy number
function class:fire(e, ox, oy, dx, dy)
	PlaySound("throw")
	self.game:addEntity(require("src.game.entities.clusterGrenade")(self.game, e, ox, oy, dx, dy))
end

return class
