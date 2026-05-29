local C = require("constants")

local Couch = {
	Image = love.graphics.newImage("assets/inbetween.png"),
	type = "couch",
}

function Couch.new(x, y)
    local instance = { x=x, y=y, width = C.TILE_SIZE*3, height = C.TILE_SIZE*2, active=true}
    setmetatable(instance, {__index = Couch})
    return instance
end


function Couch:draw()
	love.graphics.draw(self.Image, self.x, self.y)
end

return Couch
