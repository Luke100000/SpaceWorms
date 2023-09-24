---@class AsteroidWeapon : AimingWeapon
local class = require("src.game.weapons.aimingWeapon"):extend()

class.x = 5
class.y = 3

class.crosshair = Texture.crosshair.drop

class.icon = Texture.weapon.asteroid
class.description = ""

---Fire with given origin and direction
---@param e WormEntity
---@param ox number
---@param oy number
---@param dx number
---@param dy number
function class:fire(e, ox, oy, dx, dy)
	
end

return class
