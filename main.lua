local C = require("constants")
local GameState = require("gamestate")
local Audio = require("audio")
local Utils = require("utils")
local Churchy = require("churchy")
local Level = require("level")
-- TODO: require each enemy type here as they're created, e.g.:
-- local Roach = require("roach")
-- local Bird  = require("bird")
-- local Couch = require("couch")

local scale
local canvas
local churchy
local camera_x = 0
local level
-- TODO: remove this top-level image load — graphics calls outside love.load can break on some platforms
local couch = love.graphics.newImage("assets/inbetween.png")

-- TODO: add a flat entity list — everything that updates/draws/interacts lives here
-- local entities = {}

function love.resize(w, h)
	scale = math.min(w / C.VIRTUAL_W, h / C.VIRTUAL_H)
end

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setMode(C.VIRTUAL_W, C.VIRTUAL_H, { resizable = true, fullscreen = false })
	canvas = love.graphics.newCanvas(C.VIRTUAL_W, C.VIRTUAL_H)
	local windowW = love.graphics.getWidth()
	local windowH = love.graphics.getHeight()
	scale = math.min(windowW / C.VIRTUAL_W, windowH / C.VIRTUAL_H)
	churchy = Churchy.new(200, C.VIRTUAL_H - (C.TILE_SIZE * 4))
	level = Level.new()
	-- TODO: level:getSpawns() should return a list of {type, x, y} pulled from the raw map
	--       (tile 2 = ice cream, tile 3 = roach, couch = hardcoded or a special tile)
	--       Loop over spawns here and push the right entity into `entities`:
	--
	-- entities = { churchy }
	-- for _, spawn in ipairs(level:getSpawns()) do
	--     if spawn.type == "icecream" then
	--         table.insert(entities, IceCream.new(spawn.x, spawn.y))
	--     elseif spawn.type == "roach" then
	--         table.insert(entities, Roach.new(spawn.x, spawn.y))
	--     elseif spawn.type == "couch" then
	--         table.insert(entities, Couch.new(spawn.x, spawn.y))
	--     end
	-- end
	--
	-- TODO: GameState.totalIceCream = count of ice cream entities spawned
	--       win condition is: score == totalIceCream AND churchy touches couch
end

function love.update(dt)
	churchy:update(dt, level)
	camera_x = churchy.x - (C.VIRTUAL_W / 2)
	camera_x = math.max(0, camera_x)
	-- TODO: replace the above with a single entity loop:
	-- for _, e in ipairs(entities) do
	--     if e.update then e:update(dt, level, entities) end
	-- end
	-- camera still tracks churchy specifically since it's the player
	--
	-- TODO: after update loop, check win condition:
	-- if GameState.score >= GameState.totalIceCream and GameState.won then
	--     -- trigger win screen / stop updates
	-- end
	--
	-- TODO: prune dead entities (enemies stomped, ice cream collected):
	-- entities = Utils.filterAlive(entities)
end

function love.draw()
	love.graphics.setCanvas(canvas)
	love.graphics.clear()
	love.graphics.push()
	love.graphics.translate(-camera_x, 0)
	--Worldspace Draws:
	level:draw()
	churchy:draw()
	-- TODO: replace churchy:draw() + couch draw with the entity loop:
	-- for _, e in ipairs(entities) do
	--     e:draw()
	-- end
	love.graphics.draw(couch, C.VIRTUAL_W - 100, C.VIRTUAL_H - C.TILE_SIZE * 4)

	love.graphics.pop()
	--UI/MENU Draw:
	local churchyCoords = "Churchy: (" .. math.floor(churchy.x) .. "," .. math.floor(churchy.y) .. ")"
	love.graphics.print(churchyCoords, 100, 100)
	love.graphics.print("Score: " .. GameState.score, 100, 150)
	-- TODO: draw win screen when GameState.won == true

	love.graphics.setCanvas()
	local offsetX = (love.graphics.getWidth() - C.VIRTUAL_W * scale) / 2
	local offsetY = (love.graphics.getHeight() - C.VIRTUAL_H * scale) / 2
	love.graphics.draw(canvas, offsetX, offsetY, 0, scale, scale)
end

function love.keypressed(key)
	if key == "r" then
		level:reset()
		churchy:reset()
		GameState.score = 0
		-- TODO: re-run the spawn loop from love.load to rebuild `entities`
		-- TODO: reset GameState.won = false
	end
	if key == "f" then
		love.window.setFullscreen(not love.window.getFullscreen())
	end
end
