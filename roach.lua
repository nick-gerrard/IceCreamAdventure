local C = require("constants")

local Roach = {
	Image = love.graphics.newImage("assets/roach.png"),
	isEnemy = true,
	speed = 100,
	timer = 0,
}

function Roach.new(x, y)
	local instance = { x = x, y = y, width = C.TILE_SIZE, height = C.TILE_SIZE, vx = 100, active = true }
	setmetatable(instance, { __index = Roach })
	return instance
end

function Roach:update(dt, level, entities)
	self.timer = self.timer + dt
	if self.timer >= 1 then
		self.vx = -self.vx
		self.timer = 0
	end
	self.x = self.x + self.vx * dt
end

function Roach:draw()
	love.graphics.draw(self.Image, self.x, self.y)
end

return Roach
