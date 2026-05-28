local C = require("constants")

local Utils = {}

local function isSolid(tile)
	return tile == 1
end

local function isConsumable(tile)
	return tile == 2
end

local function makeTileQuery(map)
	return function(x, y)
		local col = math.floor(x / C.TILE_SIZE) + 1
		local row = math.floor(y / C.TILE_SIZE) + 1
		if map[row] and map[row][col] then
			return map[row][col]
		end
		return 0
	end
end

function Utils.resolveXCollision(entity, level)
	local getTile = makeTileQuery(level:getMap())

	local ml = getTile(entity.x, entity.y + 1)
	local ml2 = getTile(entity.x, entity.y + entity.height - 1)
	if isSolid(ml) or isSolid(ml2) then
		entity.x = math.floor(entity.x / C.TILE_SIZE) * C.TILE_SIZE + C.TILE_SIZE
		entity.vx = 0
	end

	local mr = getTile(entity.x + entity.width, entity.y + 1)
	local mr2 = getTile(entity.x + entity.width, entity.y + entity.height - 1)
	if isSolid(mr) or isSolid(mr2) then
		entity.x = math.floor((entity.x + entity.width) / C.TILE_SIZE) * C.TILE_SIZE - entity.width
		entity.vx = 0
	end
end

function Utils.resolveYCollision(entity, level)
	local getTile = makeTileQuery(level:getMap())

	local tl = getTile(entity.x + 1, entity.y)
	local tr = getTile(entity.x + entity.width - 1, entity.y)
	if isSolid(tl) or isSolid(tr) then
		entity.y = math.floor(entity.y / C.TILE_SIZE) * C.TILE_SIZE + C.TILE_SIZE
		entity.vy = 0
	end

	local bl = getTile(entity.x + 1, entity.y + entity.height)
	local br = getTile(entity.x + entity.width - 1, entity.y + entity.height)
	if isSolid(bl) or isSolid(br) then
		entity.y = math.floor((entity.y + entity.height) / C.TILE_SIZE) * C.TILE_SIZE - entity.height
		entity.vy = 0
		entity.OnGround = true
	else
		entity.OnGround = false
	end
end

function Utils.checkConsumables(entity, level)
	local map = level:getMap()
	local collected = 0
	local seen = {}

	local corners = {
		{ entity.x,                    entity.y },
		{ entity.x + entity.width - 1, entity.y },
		{ entity.x,                    entity.y + entity.height - 1 },
		{ entity.x + entity.width - 1, entity.y + entity.height - 1 },
	}

	for _, pt in ipairs(corners) do
		local col = math.floor(pt[1] / C.TILE_SIZE) + 1
		local row = math.floor(pt[2] / C.TILE_SIZE) + 1
		local key = row .. "," .. col
		if not seen[key] and map[row] and isConsumable(map[row][col]) then
			level:collectTile(row, col)
			collected = collected + 1
			seen[key] = true
		end
	end

	return collected
end

return Utils
