local C = require("constants")
local Utils = require("utils")

local Pigeon = {
	Image = love.graphics.newImage("assets/pigeon.png"),
	isEnemy = true,
}

function Pigeon.animateRun(image, width, height, duration)
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

function Pigeon.new(x, y)
	local instance = {
		x = x,
		y = y,
		width = C.TILE_SIZE,
		height = C.TILE_SIZE,
		vx = 100,
		vy = -100,
		speed = 100,
		dir = -1,
		onGround = true,
		timer = 0,
		active = true,
	}
	setmetatable(instance, { __index = Pigeon })
	instance.rightAnim = instance.animateRun(love.graphics.newImage("assets/pigeonflyright.png"), 32, 32, 0.4)
	instance.leftAnim = instance.animateRun(love.graphics.newImage("assets/pigeonflyleft.png"), 32, 32, 0.4)
	return instance
end

function Pigeon:update(dt, level, entities)
	self.timer = self.timer + dt
	self.x = self.x + self.vx * dt
	Utils.resolveXCollision(self, level)
	if self.vx == 0 then
		self.vx = self.speed * self.dir
		self.dir = -self.dir
	end
	self.vy = self.vy + C.GRAVITY * dt
	self.y = self.y + self.vy * dt
	Utils.resolveYCollision(self, level)
	if self.timer >= 2 then
		self.timer = 0
		self.vy = C.JUMP_FORCE * 0.8
		self.OnGround = false
	end
	if self.OnGround == true then
		Utils.checkEndTile(self, level)
	end
	local anim = self.vx > 0 and self.rightAnim or self.leftAnim
	anim.currentTime = (anim.currentTime + dt) % anim.duration
end

function Pigeon:draw()
	local anim = self.vx > 0 and self.rightAnim or self.leftAnim
	local frameCount = #anim.quads
	local frameIndex = math.floor(anim.currentTime / anim.duration * frameCount) + 1
	love.graphics.draw(anim.spriteSheet, anim.quads[frameIndex], self.x, self.y)
end

return Pigeon
