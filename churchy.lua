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
		active = true,
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

function Churchy:update(dt, level, entities)
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

	for _, e in ipairs(entities) do
		if e.type == "iceCream" and e.active and Utils.overlaps(self, e) then
			e.active = false
			GameState.score = GameState.score + 1
		elseif e.isEnemy and e.active and Utils.overlaps(self, e) then
			local stomped = self.vy > 0 and (self.y + self.height) < (e.y + e.height / 2)
			if stomped then
				e.active = false
				self.vy = C.JUMP_FORCE / 2
			else
				self:reset()
			end
		elseif e.type == "couch" and Utils.overlaps(self, e) and GameState.score >= GameState.totalIceCream then
			GameState.won = true
		end
	end

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
