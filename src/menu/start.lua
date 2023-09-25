---@class StartState : State
Classes.start = Clazz()

function Classes.start:switch()
	PlayMusic("menu")

	self.timer = 0
end

function Classes.start:draw()
	love.graphics.draw(Texture.startScreen)

	if love.timer.getTime() % 1.5 > 0.75 then
		love.graphics.printf("press start", 2, 60, Globals.width, "center")
	end
	love.graphics.setColor(0.3, 0.3, 0.3)
	love.graphics.printf("by luke100000 and skrill", 0, 135, Globals.width, "center")
	love.graphics.setColor(1, 1, 1)
end

function Classes.start:update(dt)
	self.timer = self.timer + dt
end

function Classes.start:keypressed(key)
	if self.timer > 0.1 then
		SwitchState(Classes.menu())
	end
end
