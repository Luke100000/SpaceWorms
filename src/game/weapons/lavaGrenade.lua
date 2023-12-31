---@class LavaGrenadeWeapon : AimingWeapon
local class = require("src.game.weapons.aimingWeapon"):extend()

class.x = 6
class.y = 3

class.crosshair = Texture.crosshair.grenade

class.icon = Texture.weapon.lavaGrenade
class.description = "A grenade filled with hot lava."

class.berries = 2
class.wood = 2
class.crystals = 2

---Fire with given origin and direction
---@param e WormEntity
---@param ox number
---@param oy number
---@param dx number
---@param dy number
function class:fire(e, ox, oy, dx, dy)
	PlaySound("throw")
	self.game:addEntity(require("src.game.entities.lavaGrenade")(self.game, e, ox, oy, dx, dy))
end

return class
