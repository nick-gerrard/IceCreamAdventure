local C = require("constants")
local GameState = require("gamestate")
local Audio = require("audio")
local Utils = require("utils")
local Churchy = require("churchy")
local Level = require("level")

local scale
local canvas
local churchy
local camera_x = 0
local level

function love.resize(w, h)
	scale = math.min(w / C.VIRTUAL_W, h / C.VIRTUAL_H)
end

function love.load()
	love.window.setMode(C.VIRTUAL_W, C.VIRTUAL_H, { resizable = true, fullscreen = false })
	canvas = love.graphics.newCanvas(C.VIRTUAL_W, C.VIRTUAL_H)
	local windowW = love.graphics.getWidth()
	local windowH = love.graphics.getHeight()
	scale = math.min(windowW / C.VIRTUAL_W, windowH / C.VIRTUAL_H)
	churchy = Churchy.new(200, C.VIRTUAL_H - (C.TILE_SIZE * 4))
	level = Level.new()
end

function love.update(dt)
	churchy:update(dt, level)
	camera_x = churchy.x - (C.VIRTUAL_W / 2)
	camera_x = math.max(0, camera_x)
end

function love.draw()
	love.graphics.setCanvas(canvas)
	love.graphics.clear()
	love.graphics.push()
	love.graphics.translate(-camera_x, 0)
	--Worldspace Draws:
	level:draw()
	churchy:draw()

	love.graphics.pop()
	--UI/MENU Draw:
	local churchyCoords = "Churchy: (" .. math.floor(churchy.x) .. "," .. math.floor(churchy.y) .. ")"
	love.graphics.print(churchyCoords, 100, 100)
	love.graphics.print("Score: " .. GameState.score, 100, 150)

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
	end
end
