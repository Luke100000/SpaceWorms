---@class Inventory : Clazz
Classes.inventory = Clazz()

function Classes.inventory:init()
	self.x = 1
	self.y = 1

	self.width = 6
	self.height = 3

	self.selectedWeapon = "shotgun"
end

function Classes.inventory:draw()
	love.graphics.draw(Texture.craftingMenu)

	--inventory
	for x = 1, self.width do
		for y = 1, self.height do
			love.graphics.draw(Texture.emptySlot, 4 + (x - 1) * 26, 4 + (y - 1) * 26)
		end
	end

	--resources
	love.graphics.draw(Texture.materialSlot, 10, 89)
	love.graphics.draw(Texture.materialSlot, 10 + 36, 89)
	love.graphics.draw(Texture.materialSlot, 10 + 36 * 2, 89)
end

function Classes.inventory:keypressed(key)
	if key == "left" then
		self.x = math.max(1, self.x - 1)
	end
	if key == "right" then
		self.x = math.min(self.width, self.x + 1)
	end
	if key == "up" then
		self.y = math.max(1, self.y - 1)
	end
	if key == "down" then
		self.y = math.min(self.height, self.y + 1)
	end
end
