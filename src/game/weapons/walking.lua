---@class WalkingWeapon : Weapon
local class = require("src.game.weapons.weapon"):extend()

class.x = 5
class.y = 1

class.icon = Texture.weapon.walking
class.description = "A singe boot to walk longer distances."

function class:init(game)
	self.super.init(self, game)

	self.used = false
end

function class:aim()
	if self.used then
		self.game.state = "done"
	else
		local e = self.game:getCurrentEntity()
		self.game.startX = e.x
		self.game.startY = e.y

		self.game.state = "move"
		self.game.power = 1
		self.game.maxDistance = 30

		self.used = true
	end
end

function class:update(dt)
	if self.used and self.game.state == "idle" then
		self.game.state = "done"
	end
end

return class
