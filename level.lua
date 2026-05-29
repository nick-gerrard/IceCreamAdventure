local C = require("constants")
local mapData = require("levels.level1")

local Level = {}
Level.__index = Level
local surfaceTexture = love.graphics.newImage("assets/surface1.png")
local skyTexture = love.graphics.newImage("assets/sky.png")

local function buildFromMapData(map, spawns)
	local tileLayer, objectLayer
	for _, layer in ipairs(mapData.layers) do
		if layer.type == "tilelayer" then
			tileLayer = layer
		elseif layer.type == "objectgroup" then
			objectLayer = layer
		end
	end

	local width = tileLayer.width
	local height = tileLayer.height
	for row = 1, height do
		map[row] = map[row] or {}
		for col = 1, width do
			local gid = tileLayer.data[(row - 1) * width + col]
			map[row][col] = gid > 0 and 1 or 0
		end
	end

	if objectLayer then
		for _, obj in ipairs(objectLayer.objects) do
			local spawnType = obj.class or obj.type
			table.insert(spawns, { type = spawnType, x = obj.x, y = obj.y })
		end
	end
end

function Level.new()
	local map = {}
	local spawns = {}
	buildFromMapData(map, spawns)
	return setmetatable({ map = map, spawns = spawns }, Level)
end

function Level:getSpawns()
	return self.spawns
end

function Level:reset()
	self.map = {}
	self.spawns = {}
	buildFromMapData(self.map, self.spawns)
end

function Level:getTile(x, y)
	local col = math.floor(x / C.TILE_SIZE) + 1
	local row = math.floor(y / C.TILE_SIZE) + 1
	if self.map[row] and self.map[row][col] then
		return self.map[row][col]
	end
	return 0
end

function Level:draw()
	for i = 1, #self.map do
		for j = 1, #self.map[i] do
			local x, y = (j - 1) * C.TILE_SIZE, (i - 1) * C.TILE_SIZE
			if self.map[i][j] == 1 then
				love.graphics.draw(surfaceTexture, x, y)
			else
				love.graphics.draw(skyTexture, x, y)
			end
			love.graphics.setColor(1, 1, 1)
		end
	end
end

function Level:getMap()
	return self.map
end

return Level
