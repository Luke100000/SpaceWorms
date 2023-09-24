---@class RocketEntity : BulletEntity
local class = require("src.game.entities.bullet"):extend()

class.range = 11
class.power = 1.2

class.width = 2
class.height = 2

return class