local C = require("constants")
local Utils = require("utils")

local Roach = {
	Image = love.graphics.newImage("assets/roach.png"),
	isEnemy = true,
}

function Roach.new(x, y)
	local instance =
		{ x = x, y = y, width = C.TILE_SIZE, height = C.TILE_SIZE, vx = 100, speed = 100, dir = -1, active = true }
	setmetatable(instance, { __index = Roach })
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
end

function Roach:draw()
	love.graphics.draw(self.Image, self.x, self.y)
end

return Roach
