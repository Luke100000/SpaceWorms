---@class BatWeapon : AimingWeapon
local class = require("src.game.weapons.aimingWeapon"):extend()

class.x = 4
class.y = 1

class.crosshair = Texture.crosshair.bat

class.icon = Texture.weapon.bat
class.description = "A sturdy piece of wood to bonk a worm into lava lakes."

class.berries = 0
class.wood = 1
class.crystals = 0

---Fire with given origin and direction
---@param e WormEntity
---@param ox number
---@param oy number
---@param dx number
---@param dy number
function class:fire(e, ox, oy, dx, dy)
	local range = 10

	for _, entity in ipairs(self.game.entities) do
		if entity ~= e then
			local distance = entity:getDistance(ox, oy)
			if distance < range and entity:instanceOf(Classes.worm) then
				---@cast entity WormEntity
				entity:hurt(1)

				entity.vx = entity.vx + dx
				entity.vy = entity.vy + dy
			end
		end
	end
end

return class
