---@class WormEntity : Entity
Classes.worm = Classes.entity:extend()

Classes.worm.width = 3
Classes.worm.height = 5

---@param game GameState
---@param enemy boolean
---@param x number
---@param y number
function Classes.worm:init(game, enemy, x, y)
	self.game = game

	self.enemy = enemy

	self.x = x - self.width / 2
	self.y = y - self.height / 2

	self.vx = 0
	self.vy = 0

	self.health = 1.0
	self.lazyHealth = 1.0
	self.dying = 0.0

	self.right = x > self.game.level.width / 2
	self.aim = 0

	self.pressingLeft = false
	self.pressingRight = false
	self.pressingJump = false
	self.pressingDown = false
end

function Classes.worm:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Classes.worm:collides()
	return self.game.level:checkCollision(math.floor(self.x), math.floor(self.y), self.width, self.height)
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
	if self.game.state == "move" then
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
	end

	-- look into direction
	if self.pressingRight ~= self.pressingLeft then
		self.right = self.pressingRight and not self.pressingLeft
	end

	-- aim
	if self.game.state == "aim" then
		local d = self.pressingJump and -1 or self.pressingDown and 1 or 0
		self.aim = math.min(math.pi / 2, math.max(-math.pi / 2, self.aim + d * dt))
	end

	-- gravity
	self.vy = self.vy + 10 * dt

	-- reset keys
	self.pressingLeft = false
	self.pressingRight = false
	self.pressingJump = false
	self.pressingDown = false

	-- dying animation
	if self.health == 0 then
		self.dying = self.dying + dt
		if self.dying > 3 then
			self.dead = true
		end
	end

	-- animate health
	local animationSpeed = 0.25 * dt
	local d = math.max(-animationSpeed, math.min(animationSpeed, self.health - self.lazyHealth))
	self.lazyHealth = self.lazyHealth + d
end

---Hurts the worm
---@param damage number
function Classes.worm:hurt(damage)
	self.health = math.max(0, self.health - damage / 10)
end
