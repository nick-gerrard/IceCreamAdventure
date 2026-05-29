local C = require("constants")
local GameState = require("gamestate")
local Audio = require("audio")
local Utils = require("utils")
local Churchy = require("churchy")
local Level = require("level")
local Roach = require("roach")
-- local Bird  = require("bird")
local Couch = require("couch")
local IceCream = require("icecream")

local scale
local canvas
local churchy
local camera_x = 0
local level
local entities = {}
function love.resize(w, h)
	scale = math.min(w / C.VIRTUAL_W, h / C.VIRTUAL_H)
end

local function buildEntities()
	entities = {}
	for _, spawn in ipairs(level:getSpawns()) do
		if spawn.type == "iceCream" then
			table.insert(entities, IceCream.new(spawn.x, spawn.y))
			GameState.totalIceCream = GameState.totalIceCream + 1
		elseif spawn.type == "roach" then
			table.insert(entities, Roach.new(spawn.x, spawn.y))
		elseif spawn.type == "couch" then
			table.insert(entities, Couch.new(spawn.x, spawn.y))
		end
	end
	table.insert(entities, churchy)
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
	buildEntities()
end

function love.update(dt)
	camera_x = churchy.x - (C.VIRTUAL_W / 2)
	camera_x = math.max(0, camera_x)
	for _, e in ipairs(entities) do
		if e.update then
			e:update(dt, level, entities)
		end
	end
	entities = Utils.filterAlive(entities)
end

function love.draw()
	love.graphics.setCanvas(canvas)
	love.graphics.clear()
	love.graphics.push()
	love.graphics.translate(-camera_x, 0)
	--Worldspace Draws:
	level:draw()
	for _, e in ipairs(entities) do
		e:draw()
	end

	love.graphics.pop()
	--UI/MENU Draw:
	local churchyCoords = "Churchy: (" .. math.floor(churchy.x) .. "," .. math.floor(churchy.y) .. ")"
	love.graphics.print(churchyCoords, 100, 100)
	love.graphics.print("Score: " .. GameState.score, 100, 130)
	love.graphics.print("Total: " .. GameState.totalIceCream, 100, 160)
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
		GameState.won = false
		GameState.totalIceCream = 0
		buildEntities()
	end
	if key == "f" then
		love.window.setFullscreen(not love.window.getFullscreen())
	end
end
