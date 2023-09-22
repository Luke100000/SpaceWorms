---@class Inventory : Clazz
Classes.inventory = Clazz()

---@param game GameState
function Classes.inventory:init(game)
	self.game = game

	self.x = 1
	self.y = 1

	self.width = 6
	self.height = 3

	self.selectedWeapon = false
end

function Classes.inventory:draw()
	love.graphics.draw(Texture.craftingMenu)

	--inventory
	for x = 1, self.width do
		for y = 1, self.height do
			love.graphics.draw(Texture.emptySlot, 4 + (x - 1) * 26, 4 + (y - 1) * 26)
		end
	end

	--weapons
	self.selectedWeapon = false
	for name, weapon in pairs(Weapons) do
		love.graphics.draw(Texture.weapon[name], 6 + (weapon.x - 1) * 26, 6 + (weapon.y - 1) * 26)

		if weapon.x == self.x and weapon.y == self.y then
			self.selectedWeapon = weapon
		end
	end

	if self.selectedWeapon then
		love.graphics.print(self.selectedWeapon.description:lower(), 3, 127)

		love.graphics.print(tostring(self.selectedWeapon.berries), 37, 108)
		love.graphics.print(tostring(self.selectedWeapon.wood), 37 + 36, 108)
		love.graphics.print(tostring(self.selectedWeapon.crystals), 37 + 36 * 2, 108)
	end

	love.graphics.draw(Texture.selectedSlot, 3 + (self.x - 1) * 26, 3 + (self.y - 1) * 26)

	--resources
	love.graphics.draw(Texture.emptyMaterialSlot, 10, 89)
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

	if self.game.inventoryOpen and (key == "space" or key == "escape" or key == "return") then
		self.game.inventoryOpen = false

		self.game.weapon = nil
		if self.selectedWeapon then
			self.game.weapon = self.selectedWeapon(self.game)
		end
	end
end
