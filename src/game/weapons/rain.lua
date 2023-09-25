---@class RainWeapon : AimingWeapon
local class = require("src.game.weapons.aimingWeapon"):extend()

class.x = 5
class.y = 2

class.crosshair = Texture.crosshair.drop

class.icon = Texture.weapon.rain
class.description = "Let your enemies drown under a massive rain cloud."

class.power = false
class.maxStrength = 80
class.crosshairDistance = class.maxStrength

class.berries = 2
class.wood = 0
class.crystals = 0

function class:init(game)
	class.super.init(self, game)

	self.ammo = 20
	self.cooldown = 0
	self.pos = 0
end

---Fire with given origin and direction
---@param e WormEntity
---@param ox number
---@param oy number
---@param dx number
---@param dy number
function class:fire(e, ox, oy, dx, dy)
	self.pos = ox + dx
end

function class:update(dt)
	if self.game.state == "done" then
		self.cooldown = self.cooldown - dt
		if self.cooldown < 0 then
			self.cooldown = self.cooldown + 1 / 10

			local cx = math.random(-10, 10) + math.floor(self.pos)
			local cy = math.random(1, 8)
			for _, r in ipairs({ { -1, 0 }, { 1, 0 }, { 0, -1 }, { 0, 1 }, { 0, 0 } }) do
				local b = self.game.level:getBlock(cx + r[1], cy + r[2])
				if b == Blocks.AIR then
					self.game.level:setBlock(cx + r[1], cy + r[2], Blocks.WATER)
				end
			end
		end
	end
	return true
end

return class
