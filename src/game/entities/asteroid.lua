---@class AsteroidEntity : Entity
local class = require("src.game.entities.bullet"):extend()

class.range = 20
class.power = 1.5

class.width = 5
class.height = 5

return class