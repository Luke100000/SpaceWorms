---@class WormEntity : Entity
local class = require("src.game.entities.entity"):extend()

class.width = 4
class.height = 5

---@param game GameState
---@param enemy boolean
---@param x number
---@param y number
function class:init(game, enemy, x, y)
	class.super.init(self, game)

	self.enemy = enemy

	self.x = x - self.width / 2
	self.y = y - self.height / 2

	self.vx = 0
	self.vy = 0

	self.health = 1.0
	self.lazyHealth = 1.0
	self.dying = 0.0

	self.right = x < self.game.level.width / 2
	self.aim = 0

	self.seed = math.random()

	self.lastInstantDamage = -1
	self.lastLadder = false

	self.pressingLeft = false
	self.pressingRight = false
	self.pressingJump = false
	self.pressingDown = false
end

function class:draw()
	if self.dying > 0 then
		local tex = self.enemy and Texture.enemyWormDies or Texture.friendlyWormDies
		local frame = math.max(1, math.min(10, math.ceil(self.dying / 3 * 10)))
		love.graphics.draw(tex, Quads.death[frame], math.floor(self.x + 0.5), math.floor(self.y + 0.5), 0,
			self.right and -1 or 1, 1, 3, 3)
	else
		local quad = "normal"
		if self.vy < 0 then
			quad = "jump"
		else
			local time = self.seed + love.timer.getTime() * (1.0 + self.seed * 0.1)
			if self.game:getCurrentEntity() == self and time % 1 > 0.5 then
				if self.pressingLeft or self.pressingRight then
					quad = "walk"
				else
					quad = "idle"
				end
			elseif time % 1 > 0.5 then
				quad = "look"
			end
		end

		local tex = self.enemy and Texture.enemyWorm or Texture.friendlyWorm
		love.graphics.draw(tex, Quads.worms[quad], math.ceil(self:getCenterX()) - 1, math.ceil(self:getCenterY()) - 2, 0,
			self.right and -1 or 1, 1, 3, 4)
	end
end

function class:control(left, right, up, down)
	if self.health > 0 then
		self.pressingLeft = left
		self.pressingRight = right
		self.pressingJump = up
		self.pressingDown = down
	end
end

function class:update(dt)
	-- horizontal physics
	local oldX = self.x
	self.x = self.x + self.vx * dt
	local flags = self:collides()
	if flags.collided or (flags.ladder and not self.lastLadder and not self.pressingDown) then
		local collided = true
		if not self.pressingDown then
			for i = 1, 2 do
				local oldY = self.y
				self.y = self.y - i - 0.5
				flags = self:collides()
				if flags.collided then
					self.y = oldY
				else
					collided = false
					break
				end
			end
		end

		if collided then
			self.x = oldX
			self.vx = 0
		end
	end

	self.lastLadder = flags.ladder

	-- vertical physics
	local onGround = false
	local oldY = self.y
	self.y = self.y + self.vy * dt
	local verticalFlags = self:collides()
	if verticalFlags.collided or (self.vy >= 0 and verticalFlags.ladder and not self.pressingDown) then
		self.y = oldY

		if self.vy > 0 then
			onGround = true
		end

		self.vy = 0
		self.vx = 0
	else
		if verticalFlags.instantDamage > 0 and self.lastInstantDamage ~= self.game.turn then
			self.lastInstantDamage = self.game.turn
			self:hurt(verticalFlags.instantDamage)
		end
	end

	-- damping
	self.vx = self.vx * (1 - verticalFlags.damping * dt)
	self.vy = self.vy * (1 - verticalFlags.damping * dt)

	-- movement
	if self.game.state == "move" then
		if onGround then
			if self.pressingJump then
				self.vy = -15
				PlaySound("jump")
			end
		end
		if self.pressingLeft and not self.pressingRight then
			self.vx = math.min(self.vx, onGround and -7 or -5)
		end
		if not self.pressingLeft and self.pressingRight then
			self.vx = math.max(self.vx, onGround and 7 or 5)
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

	-- harvesting berries
	local x, y = self:getFlooredCenterX(), self:getFlooredCenterY()
	local b = self.game.level:getBlock(x, y)
	if b.berries > 0 then
		self.game:mineAndCollect(x, y, 1, 24)
	end

	return self.x ~= oldX or self.y ~= oldY
end

function class:nextTurn()
	local flags = self:collides()
	if flags.damage > 0 then
		self.lastInstantDamage = self.game.turn
		self:hurt(flags.instantDamage)
	end

	local b = self.game.level:getBlock(math.floor(self:getCenterX()), math.floor(self:getCenterY() - 2))
	if b.damping > 0 or b.collision == 2 then
		self:hurt(1)
	end
end

---Hurts the worm
---@param damage number
function class:hurt(damage)
	self.health = math.max(0, self.health - damage / 10)
	PlaySound("hurt")
end

return class
