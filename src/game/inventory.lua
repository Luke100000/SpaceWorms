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

function Classes.inventory:canAfford(weapon)
	local res = self.game:getCurrentResources()
	return res.weapons[weapon.name] > 0 or
		(res.berries >= weapon.berries and res.wood >= weapon.wood and res.crystals >= weapon.crystals)
end

function Classes.inventory:draw()
	love.graphics.draw(Texture.craftingMenu)

	local res = self.game:getCurrentResources()

	--weapons
	local lookup = {}
	self.selectedWeapon = false
	for name, weapon in pairs(Weapons) do
		if not self:canAfford(weapon) then
			love.graphics.setColor(0.5, 0.5, 0.5)
		end
		love.graphics.draw(Texture.weapon[name], 5 + (weapon.x - 1) * 26, 5 + (weapon.y - 1) * 26)
		love.graphics.setColor(1, 1, 1)

		if weapon.x == self.x and weapon.y == self.y then
			self.selectedWeapon = weapon
		end

		local count = res.weapons[weapon.name] or 0
		if count > 0 then
			love.graphics.print(tostring(count), 21 + (weapon.x - 1) * 26, 21 + (weapon.y - 1) * 26)
		end

		lookup[weapon.x * 100 + weapon.y] = weapon
	end

	--inventory
	for x = 1, self.width do
		for y = 1, self.height do
			local weapon = lookup[x * 100 + y]
			local count = weapon and res.weapons[weapon.name] or 0
			love.graphics.draw(count > 0 and Texture.fullSlot or Texture.emptySlot, 4 + (x - 1) * 26, 4 + (y - 1) * 26)
		end
	end

	--show costs
	if self.selectedWeapon then
		love.graphics.printf(self.selectedWeapon.description:lower(), 3, 128, Globals.width - 6, "left")

		if self.selectedWeapon.berries > 0 then
			love.graphics.print(tostring(self.selectedWeapon.berries), 37, 108)
		end
		if self.selectedWeapon.wood > 0 then
			love.graphics.print(tostring(self.selectedWeapon.wood), 37 + 36, 108)
		end
		if self.selectedWeapon.crystals > 0 then
			love.graphics.print(tostring(self.selectedWeapon.crystals), 37 + 36 * 2, 108)
		end
	end

	--slot selection
	local count = self.selectedWeapon and res.weapons[self.selectedWeapon.name] or 0
	love.graphics.draw(count > 0 and Texture.selectedFullSlot or Texture.selectedSlot, 3 + (self.x - 1) * 26, 3 + (self.y - 1) * 26)

	--resources
	local res = self.game:getCurrentResources()
	love.graphics.draw(
		self.selectedWeapon and self.selectedWeapon.berries > 0 and Texture.materialSlot or Texture.emptyMaterialSlot, 10,
		89)
	love.graphics.draw(
		self.selectedWeapon and self.selectedWeapon.wood > 0 and Texture.materialSlot or Texture.emptyMaterialSlot,
		10 + 36,
		89)
	love.graphics.draw(
		self.selectedWeapon and self.selectedWeapon.crystals > 0 and Texture.materialSlot or Texture.emptyMaterialSlot,
		10 + 36 * 2, 89)

	love.graphics.draw(Texture.resources.berries, 12, 91)
	love.graphics.draw(Texture.resources.wood, 12 + 36, 91)
	love.graphics.draw(Texture.resources.crystals, 12 + 36 * 2, 91)

	love.graphics.print(tostring(res.berries), 29, 108)
	love.graphics.print(tostring(res.wood), 29 + 36, 108)
	love.graphics.print(tostring(res.crystals), 29 + 36 * 2, 108)
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

		if self.selectedWeapon and self:canAfford(self.selectedWeapon) then
			self.game.weapon = self.selectedWeapon(self.game)
		end
	end
end
