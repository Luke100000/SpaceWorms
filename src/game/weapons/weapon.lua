---@class Weapon : Clazz
local class = Clazz()

class.x = 1
class.y = 1

class.icon = Texture.weapon.bat
class.description = ""

class.power = true

class.berries = 0
class.wood = 0
class.crystals = 0

class.name = ""

---@param game GameState
function class:init(game)
	self.game = game
	self.paid = false
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
