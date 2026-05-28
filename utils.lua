local C = require("constants")

local Utils = {}

function Utils.resolveCollision(entity, level)
	local map = level:getMap()

	local function getTile(x, y)
		local col = math.floor(x / C.TILE_SIZE) + 1
		local row = math.floor(y / C.TILE_SIZE) + 1
		if map[row] and map[row][col] then
			if map[row][col] == 1 then
				print(map[row][col])
			end
			return map[row][col]
		end
		return 0
	end

	local bl = getTile(entity.x + 1, entity.y + entity.height)
	local br = getTile(entity.x + entity.width, entity.y + entity.height)
	if bl > 0 or br > 0 then
		entity.y = math.floor((entity.y + entity.height) / C.TILE_SIZE) * C.TILE_SIZE - C.TILE_SIZE
		entity.vy = 0
		entity.OnGround = true
	else
		entity.OnGround = false
	end
	local tl = getTile(entity.x + 1, entity.y)
	local tr = getTile(entity.x + entity.width - 1, entity.y)
	if tl > 0 or tr > 0 then
		entity.y = math.floor(entity.y / C.TILE_SIZE) * C.TILE_SIZE + C.TILE_SIZE
		entity.vy = 0
	end

	local ml = getTile(entity.x, entity.y + 1)
	local ml2 = getTile(entity.x, entity.y + entity.height - 1)
	if ml > 0 or ml2 > 0 then
		entity.x = math.floor(entity.x / C.TILE_SIZE) * C.TILE_SIZE + C.TILE_SIZE
		entity.vx = 0
	end

	local mr = getTile(entity.x + entity.width, entity.y + 1)
	local mr2 = getTile(entity.x + entity.width, entity.y + entity.height - 1)
	if mr > 0 or mr2 > 0 then
		entity.x = math.floor((entity.x + entity.width) / C.TILE_SIZE) * C.TILE_SIZE - entity.width
		entity.vx = 0
	end
end

return Utils
