local GameState = {
	score = 0,
	-- TODO: add totalIceCream — set in love.load after counting ice cream spawns,
	--       used as the threshold for the win condition check in churchy:update
	-- totalIceCream = 0,
	-- TODO: add won flag — set to true when churchy reaches the couch with full score,
	--       checked in love.update to halt updates and in love.draw to show win screen
	-- won = false,
}

return GameState
