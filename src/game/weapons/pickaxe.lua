---@class PickaxeWeapon : Weapon
local class = require("src.game.weapons.weapon"):extend()

class.x = 1
class.y = 1

class.icon = Texture.weapon.pickaxe
class.description = "A rusty pickaxe! Mine wood and crystals to craft weapons."

---@param game GameState
function class:init(game)
	class.super.init(self, game)
end

function class:aim()
	self.game.state = "done"
	local e = self.game:getCurrentEntity()

	self.game:mineAndCollect(e.x, e.y, 8, 16)
end

return class
