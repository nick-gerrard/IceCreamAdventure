local C = require("constants")

local Utils = {}

local function isSolid(tile)
	return tile == 1
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

local function getSubTile(map)
	return function(x, y)
		local col = math.floor(x / C.TILE_SIZE) + 1
		local row = math.floor(y / C.TILE_SIZE)
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

function Utils.checkEndTile(entity, level)
	local getTile = makeTileQuery(level:getMap())
	local leadingX = entity.vx > 0 and (entity.x + entity.width) or entity.x
	if not isSolid(getTile(leadingX, entity.y + entity.height + 1)) then
		entity.vx = -entity.vx
	end
end

function Utils.overlaps(a, b)
	return a.x < b.x + b.width and a.x + a.width > b.x and a.y < b.y + b.height and a.y + a.height > b.y
end
function Utils.filterAlive(entities)
	local alive = {}
	for _, e in ipairs(entities) do
		if e.active then
			table.insert(alive, e)
		end
	end
	return alive
end

return Utils
