---@class GrenadeEntity : BulletEntity
local class = require("src.game.entities.bullet"):extend()

class.bounciness = 0.9
class.range = 10
class.power = 1

class.width = 3
class.height = 3

return class