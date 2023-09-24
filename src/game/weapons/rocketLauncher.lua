---@class RocketLauncherWeapon : AimingWeapon
local class = require("src.game.weapons.aimingWeapon"):extend()

class.x = 3
class.y = 2

class.crosshair = Texture.crosshair.rocket

class.icon = Texture.weapon.rocketLauncher
class.description = "Launches a high explosive rocket."

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
