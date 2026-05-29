local C = require("constants")
local Utils = require("utils")
local GameState = require("gamestate")

local rightImage = love.graphics.newImage("assets/churchy.png")
local leftImage = love.graphics.newImage("assets/churchyflipped.png")
local Churchy = {}

Churchy.__index = Churchy

function Churchy.new(x, y)
	local self = setmetatable({
		x = x,
		y = y,
		width = C.TILE_SIZE,
		height = C.TILE_SIZE,
		vx = 0,
		vy = 0,
		speed = 220,
		image = rightImage,
	}, Churchy)

	self.runRightAnim = self:animateRun(love.graphics.newImage("assets/churchyrunright.png"), 32, 32, 0.2)
	self.runLeftAnim = self:animateRun(love.graphics.newImage("assets/churchyrunleft.png"), 32, 32, 0.2)

	return self
end

function Churchy:animateRun(image, width, height, duration)
	local animation = {}
	animation.spriteSheet = image
	animation.quads = {}
	for y = 0, image:getHeight() - height, height do
		for x = 0, image:getWidth() - width, width do
			table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
		end
	end
	animation.duration = duration or 1
	animation.currentTime = 0
	return animation
end

function Churchy:update(dt, level)
	self.vx = 0
	if love.keyboard.isDown("d") then
		self.image = rightImage
		self.vx = self.speed
	end
	if love.keyboard.isDown("a") then
		self.image = leftImage
		self.vx = -self.speed
	end

	if self.vx ~= 0 then
		local anim = self.vx > 0 and self.runRightAnim or self.runLeftAnim
		anim.currentTime = (anim.currentTime + dt) % anim.duration
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

function Churchy:reset()
	self.x = 100
	self.y = C.VIRTUAL_H - C.TILE_SIZE * 3
end

function Churchy:isDead()
	if self.y > C.VIRTUAL_H then
		self:reset()
	end
end

function Churchy:draw()
	love.graphics.setColor(1, 1, 1)
	if self.vx ~= 0 then
		local anim = self.vx > 0 and self.runRightAnim or self.runLeftAnim
		local frameCount = #anim.quads
		local frameIndex = math.floor(anim.currentTime / anim.duration * frameCount) + 1
		love.graphics.draw(anim.spriteSheet, anim.quads[frameIndex], self.x, self.y)
	else
		love.graphics.draw(self.image, self.x, self.y)
	end
end

return Churchy
