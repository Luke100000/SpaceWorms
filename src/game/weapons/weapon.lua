---@class Weapon : Clazz
local class = Clazz()

class.x = 1
class.y = 1

class.icon = Texture.weapon.bat
class.description = ""

class.berries = 0
class.wood = 0
class.crystals = 0

---@param game GameState
function class:init(game)
	self.game = game
end

function class:draw()

end

function class:aim()

end

function class:trigger()

end

---@param dt number
function class:update(dt)

end

return class
