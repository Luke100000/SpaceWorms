---@class ShotgunWeapon : AimingWeapon
local class = require("src.game.weapons.aimingWeapon"):extend()

class.x = 2
class.y = 1

class.icon = Texture.weapon.shotgun
class.description = "A shotgun"

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
