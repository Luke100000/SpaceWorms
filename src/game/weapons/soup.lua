---@class SoupWeapon : Weapon
local class = require("src.game.weapons.weapon"):extend()

class.x = 3
class.y = 1

class.icon = Texture.weapon.soup
class.description = "A tasty soup made of berries and radioactive water. Heals 50%."

class.berries = 2
class.wood = 0
class.crystals = 0

---@param game GameState
function class:init(game)
	class.super.init(self, game)
end

function class:aim()
	self.game.state = "done"
	local e = self.game:getCurrentEntity()

	e.health = e.health + (1 - e.health) * 0.5
end

return class
