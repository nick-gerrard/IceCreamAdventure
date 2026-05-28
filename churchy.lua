local C = require("constants")
local Utils = require("utils")

local Churchy = {}

Churchy.__index = Churchy

function Churchy.new(x, y)
	return setmetatable({
		x = x,
		y = y,
		width = C.TILE_SIZE,
		height = C.TILE_SIZE,
		vx = 0,
		vy = 0,
		speed = 220,
		image = love.graphics.newImage("assets/churchy.png")
	}, Churchy)
end

function Churchy:update(dt, level)
	self.vx = 0
	if love.keyboard.isDown("d") then
		self.vx = self.speed
	end
	if love.keyboard.isDown("a") then
		self.vx = -self.speed
	end
	if love.keyboard.isDown("space") and self.OnGround == true then
		self:jump()
	end

	self.vy = self.vy + C.GRAVITY * dt
	self.x = self.x + self.vx * dt
	self.y = self.y + self.vy * dt

	Utils.resolveCollision(self, level)
	self:isDead()
end

function Churchy:jump()
	if self.OnGround then
		self.vy = C.JUMP_FORCE
		self.onGround = false
	end
end

function Churchy:isDead()
	if self.y < 0 then
		self.y = 10
	end
end

function Churchy:draw()
	love.graphics.draw(self.image, self.x, self.y)
	love.graphics.setColor(1, 1, 1)
end

return Churchy
