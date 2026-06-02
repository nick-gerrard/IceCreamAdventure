Timer = {
	seconds = 0,
	running = false,
}

function Timer.update(dt)
	if Timer.running == true then
		Timer.seconds = Timer.seconds + dt
	end
end

function Timer.toggle()
	Timer.running = not Timer.running
end

function Timer.display()
	local minutes = math.floor(Timer.seconds / 60)
	local secs = math.floor(Timer.seconds % 60)
	return minutes .. ":" .. secs
end

function Timer.reset()
	Timer.seconds = 0
	Timer.running = true
end

return Timer
