---@class MenuState : State
Classes.menu = Clazz()

local maps = {}
for i = 1, 9 do
	maps[i] = love.graphics.newImage("data/levels/" .. i .. ".png")
end

function Classes.menu:init()
	self.x = 1
	self.y = 1
	self.human = false
	self.progress = {}
	for i = 1, 9 do
		self.progress[i] = love.filesystem.getInfo(tostring(i))
	end
end

function Classes.menu:switch()
	PlayMusic("menu")
end

function Classes.menu:draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(Texture.mainMenu)

	for x = 1, 3 do
		for y = 1, 3 do
			local i = x + (y - 1) * 3

			love.graphics.draw(maps[i], (x - 1) * 52 + 6, (y - 1) * 41 + 6, 0, 44 / maps[i]:getWidth(),
				35 / maps[i]:getHeight())

			local tex = self.progress[i] and Texture.levelSlotWon or Texture.levelSlot
			love.graphics.draw(tex, (x - 1) * 52 + 4, (y - 1) * 41 + 4)
		end
	end

	love.graphics.draw(Texture.levelSlotSelected, (self.x - 1) * 52 + 4, (self.y - 1) * 41 + 4)

	love.graphics.printf(self.human and "space for cpu" or "space for coop", 0, 132, Globals.width, "center")
end

function Classes.menu:update(dt)

end

function Classes.menu:keypressed(key)
	if key == "left" then
		self.x = math.max(1, self.x - 1)
		PlaySound("click")
	end
	if key == "right" then
		self.x = math.min(3, self.x + 1)
		PlaySound("click")
	end
	if key == "up" then
		self.y = math.max(1, self.y - 1)
		PlaySound("click")
	end
	if key == "down" then
		self.y = math.min(3, self.y + 1)
		PlaySound("click")
	end

	if key == "return" then
		SwitchState(Classes.game(self.x + (self.y - 1) * 3, self.human))
	end

	if key == "space" then
		self.human = not self.human
	end
end
