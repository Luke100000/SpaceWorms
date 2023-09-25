---@class Particle : Clazz
Classes.particle = Clazz()

function Classes.particle:init(x, y)
	self.dead = false
	self.time = math.random() * 2 + 1
	self.x = x
	self.y = y
end

function Classes.particle:draw()
	love.graphics.draw(Texture.particle, self.x, self.y, self.time, 0.5, 0.5, 2.5, 2.5)
end

function Classes.particle:update(dt)
	self.time = self.time - dt
	self.y = self.y - dt * 5
	if self.time < 0 then
		self.dead = true
	end
end
