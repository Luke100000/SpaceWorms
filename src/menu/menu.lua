---@class MenuState : State
Classes.menu = Clazz()

function Classes.menu:switch()
	PlayMusic("menu")
end

function Classes.menu:draw()
	love.graphics.clear(1, 1, 1)
end

function Classes.menu:update(dt)

end

function Classes.menu:keypressed(key)

end
