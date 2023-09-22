---@class ShotgunWeapon : Weapon
local class = require("src.game.weapons.weapon"):extend()

class.x = 1
class.y = 1

class.description = "A shotgun"

function class:draw()

end

function class:trigger()

end

---@param dt number
function class:update(dt)

end

return class
