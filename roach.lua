local C = require("constants")
local Utils = require("utils")

local Roach = {
	Image = love.graphics.newImage("assets/roach.png"),
	isEnemy = true,
}

function Roach.animateRun(image, width, height, duration)
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

function Roach.new(x, y)
	local instance =
		{ x = x, y = y, width = C.TILE_SIZE, height = C.TILE_SIZE, vx = 100, speed = 100, dir = -1, active = true }
	setmetatable(instance, { __index = Roach })
	instance.rightAnim = instance.animateRun(love.graphics.newImage("assets/roachright.png"), 32, 32, 0.4)
	instance.leftAnim = instance.animateRun(love.graphics.newImage("assets/roachleft.png"), 32, 32, 0.4)
	return instance
end

function Roach:update(dt, level, entities)
	self.x = self.x + self.vx * dt
	Utils.resolveXCollision(self, level)
	if self.vx == 0 then
		self.vx = self.speed * self.dir
		self.dir = -self.dir
	end
	Utils.checkEndTile(self, level)
	local anim = self.vx > 0 and self.rightAnim or self.leftAnim
	anim.currentTime = (anim.currentTime + dt) % anim.duration
end

function Roach:draw()
	local anim = self.vx > 0 and self.rightAnim or self.leftAnim
	local frameCount = #anim.quads
	local frameIndex = math.floor(anim.currentTime / anim.duration * frameCount) + 1
	love.graphics.draw(anim.spriteSheet, anim.quads[frameIndex], self.x, self.y)
end

return Roach
