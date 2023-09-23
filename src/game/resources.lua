---@class Resources : Clazz
Classes.resources = Clazz()

function Classes.resources:init()
	self.berries = 3
	self.wood = 2
	self.crystals = 1

	self.weapons = { }
	for name, _ in ipairs(Weapons) do
		self.weapons[name] = 0
	end
end