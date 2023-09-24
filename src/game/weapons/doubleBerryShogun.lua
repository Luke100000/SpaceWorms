---@class DoubleBerryShotgun : AimingWeapon
local class = require("src.game.weapons.aimingWeapon"):extend()

class.x = 1
class.y = 2

class.maxStrength = 100
class.power = false

class.icon = Texture.weapon.doubleBerryShogun
class.description = "Kill one bird with two shots."

class.berries = 2
class.wood = 2
class.crystals = 0

function class:init(game)
	class.super.init(self, game)

	self.ammo = 2
end

---Fire with given origin and direction
---@param e WormEntity
---@param ox number
---@param oy number
---@param dx number
---@param dy number
function class:fire(e, ox, oy, dx, dy)
	self.game:addEntity(require("src.game.entities.bullet")(self.game, e, ox, oy, dx, dy))

	self.ammo = self.ammo - 1
	if self.ammo > 0 then
		self.game.state = "aim"
	end
end

return class
