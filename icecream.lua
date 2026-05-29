local C = require("constants")
local IceCream = {
	Image = love.graphics.newImage("assets/icecream.png"),
	type = "iceCream",
}

function IceCream.new(x, y)
	local instance = {x=x, y=y, width=C.TILE_SIZE, height=C.TILE_SIZE, active=true}
	setmetatable(instance, {__index = IceCream})
	return instance
end


function IceCream:draw()
	love.graphics.draw(self.Image, self.x, self.y)
end

return IceCream
