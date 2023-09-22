---@class WormEntity : Entity
Classes.worm = Classes.entity:extend()

---@param game GameState
---@param enemy boolean
---@param x number
---@param y number
function Classes.worm:init(game, enemy, x, y)
	self.game = game

	self.enemy = enemy

	self.x = x
	self.y = y

	self.vx = 0
	self.vy = 0

	self.pressingLeft = false
	self.pressingRight = false
	self.pressingJump = false
	self.pressingDown = false
end

function Classes.worm:draw()
	love.graphics.rectangle("fill", self.x - 1, self.y - 5, 3, 5)
end

function Classes.worm:collides()
	return self.game.level:checkCollision(math.floor(self.x) - 1, math.floor(self.y) - 5, 3, 5)
end

function Classes.worm:control(left, right, up, down)
	self.pressingLeft = left
	self.pressingRight = right
	self.pressingJump = up
	self.pressingDown = down
end

function Classes.worm:update(dt)
	-- horizontal physics
	local oldX = self.x
	self.x = self.x + self.vx * dt
	if self:collides() then
		self.x = oldX
		self.vx = 0
	end

	-- vertical physics
	local onGround = false
	local oldY = self.y
	self.y = self.y + self.vy * dt
	if self:collides() then
		self.y = oldY

		if self.vy > 0 then
			onGround = true
		end

		self.vy = 0
		self.vx = 0
	end

	-- movement
	if onGround then
		if self.pressingJump then
			self.vy = -15
		end
	end
	if self.pressingLeft and not self.pressingRight then
		self.vx = math.min(self.vx, onGround and -7 or -3)
	end
	if not self.pressingLeft and self.pressingRight then
		self.vx = math.max(self.vx, onGround and 7 or 3)
	end

	self.vy = self.vy + 10 * dt

	-- reset keys
	self.pressingLeft = false
	self.pressingRight = false
	self.pressingJump = false
	self.pressingDown = false
end
