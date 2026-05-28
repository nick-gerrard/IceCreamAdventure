local C = require("constants")
local Utils = require("utils")
local GameState = require("gamestate")

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
		image = love.graphics.newImage("assets/churchy.png"),
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

	self.x = self.x + self.vx * dt
	Utils.resolveXCollision(self, level)

	if love.keyboard.isDown("space") and self.OnGround == true then
		self:jump()
	end
	self.vy = self.vy + C.GRAVITY * dt
	self.y = self.y + self.vy * dt
	Utils.resolveYCollision(self, level)
	GameState.score = GameState.score + Utils.checkConsumables(self, level)

	self:isDead()
end

function Churchy:jump()
	if self.OnGround then
		self.vy = C.JUMP_FORCE
		self.OnGround = false
	end
end

function Churchy:isDead()
	if self.y > C.VIRTUAL_H then
		self.y = C.VIRTUAL_H - C.TILE_SIZE * 4
	end
end

function Churchy:draw()
	love.graphics.draw(self.image, self.x, self.y)
	love.graphics.setColor(1, 1, 1)
end

return Churchy
