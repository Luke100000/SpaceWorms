---@class Resources : Clazz
Classes.resources = Clazz()

function Classes.resources:init(other)
	self.berries = 3
	self.wood = 2
	self.crystals = 1

	self.weapons = {}
	for name, weapon in pairs(Weapons) do
		local costs = weapon.berries + weapon.wood + weapon.crystals
		self.weapons[name] = costs > 0 and (other and other.weapons[name] or math.max(0, math.random(-3, 3))) or 0
	end
end
