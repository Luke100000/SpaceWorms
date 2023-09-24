---@class AsteroidWeapon : AimingWeapon
local class = require("src.game.weapons.aimingWeapon"):extend()

class.x = 5
class.y = 3

class.crosshair = Texture.crosshair.drop

class.icon = Texture.weapon.asteroid
class.description = "Summon a giant asteroid from space!"

class.power = false
class.maxStrength = 80
class.crosshairDistance = class.maxStrength

---Fire with given origin and direction
---@param e WormEntity
---@param ox number
---@param oy number
---@param dx number
---@param dy number
function class:fire(e, ox, oy, dx, dy)
	local size = 3
	local tx = math.max(size, math.min(self.game.level.width - size, ox + dx))
	self.game:addEntity(require("src.game.entities.asteroid")(self.game, e, tx, -size, 0, 30))
end

return class
