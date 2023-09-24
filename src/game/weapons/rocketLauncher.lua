---@class RocketLauncherWeapon : AimingWeapon
local class = require("src.game.weapons.aimingWeapon"):extend()

class.x = 3
class.y = 2

class.crosshair = Texture.crosshair.rocket

class.icon = Texture.weapon.rocketLauncher
class.description = "Launches a high explosive rocket."

class.berries = 0
class.wood = 3
class.crystals = 1

class.maxStrength = 50

---Fire with given origin and direction
---@param e WormEntity
---@param ox number
---@param oy number
---@param dx number
---@param dy number
function class:fire(e, ox, oy, dx, dy)
	self.game:addEntity(require("src.game.entities.rocket")(self.game, e, ox, oy, dx, dy))
end

return class
