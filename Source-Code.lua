playerx = 4
playery = 4
playercolor = 15
framecount = 0

deadcolor = 1
alivecolor = 15
boards = {{},{}}

gamestate = "start"

function _init()
	boards = {{},{}}
	for y = 0, 33 do
		boards[1][y]={}
		boards[2][y]={}
		for x = 0, 33 do
			boards[1][y][x] = 0
			boards[2][y][x] = 0
		end
	end
	playerx = 4
	playery = 4
	framecount = 0
	gamestate = "start"
	menuitem( 1, "start cycle", nextstate)
end

function _update()
	if gamestate == "start" then
		_startupdate()
	elseif gamestate == "game" then
		_gameupdate()
	elseif gamestate == "cycle" then
		_cycleupdate()
	elseif gamestate == "rules" then
		_rulesupdate()
	end
	framecount += 1
end	

function _startupdate()
	if btn(4) then
		nextstate()
	end
end

function _rulesupdate()
	if framecount > 10 then
		if btn (4) then
			nextstate()
		end
	end
end

function _gameupdate()
	if framecount == 2 then
		getinput()
		framecount = 0
	end
end

function _cycleupdate()
	if framecount == 21 then
			makenewboard()
			framecount = 0
	end
end

function _draw()
		rectfill(0,0,128,128, 1)
		if gamestate == "start" then
			_drawstart()
		elseif gamestate == "game" then
			_drawgame()
		elseif gamestate == "cycle" then
			_drawcycle()
		elseif gamestate == "rules" then
			_drawrules()
		end
end		

function _drawstart()
	print("start game ?", 40, 40, 15)
	if framecount < 12 then
		print("press a", 49, 60, 15)
	end
	if framecount == 20 then
		framecount = 0
	end
end

function _drawrules()
	print("rules:", 4, 4, 15)
	print("- if a live cell is surrounded", 4,12,15)
	print("by 3 live cells it will live", 4,20,15)
	print("until the next generation.",4,28,15)
	print("otherwise it will die.",4,36,15)

	print("- if a dead cell is surrounded", 4,52,15)
	print("by 3 live cells it become live", 4,60,15)
	print("for the next generation.",4,68,15)
	print("otherwise it will remain dead.",4,76,15)

	print("- use a/b to change a cell's", 4, 92, 15)
	print("state to live/dead.", 4, 100, 15)
end

function _drawgame()
	drawcurboard()
	circ(playerx, playery, 4, playercolor)
end

function _drawcycle()
		drawcurboard()
end

function getinput()
	if btn(0) and playerx > 4 then
		playerx -= 8
	end
	
	if btn(1) and playerx < 124 then
		playerx += 8
	end
		
	if btn(2) and playery > 4 then
		playery -= 8
	end
	
	if btn(3) and playery < 124 then
	 playery += 8
	end
	
	if btn(4) then
			boards[1][(playery - 4) / 8][(playerx - 4) / 8] = 1
	end
	
	if btn(5) then
			boards[1][(playery - 4) / 8][(playerx - 4) / 8] = 0
	end
	
end
		
function drawcurboard()
	for y = 0, 31 do
		for x = 0, 31 do
			if boards[1][y][x] == 0 then
				circfill(4 + x*8,4 + y*8, 3, deadcolor)
			elseif boards[1][y][x] == 1 then
				circfill(4 + x*8,4 + y*8, 3, alivecolor)
			end
		end
	end	
end
	
function nextstate()
	framecount = 0
	if gamestate == "start" then
		gamestate = "rules"
	elseif gamestate == "rules" then
		gamestate = "game"	
	elseif gamestate == "game" then
		gamestate = "cycle"
	elseif gamestate == "cycle" then
		gamestate = "start"
	end
end

function makenewboard()
	for y = 0, 31 do
		for x = 0, 31 do
			if boards[1][y][x] == 1 then
				if neighboursum(x,y) == 3
				or neighboursum(x,y) == 2 then
					boards[2][y][x] = 1
				else
					boards[2][y][x] = 0
				end
			else
				 if neighboursum(x,y) == 3 then	 
						boards[2][y][x] = 1
					else
						boards[2][y][x] = 0
					end
			end
		end
	end
	
	for y = 0, 31 do
		for x = 0, 31 do
			boards[1][y][x] = boards[2][y][x]
		end
	end
end

function neighboursum(x, y)
	sum = 0
	
	if x == 0 and y == 0 then
		sum += boards[1][y][x+1]
		sum += boards[1][y+1][x+1]
		sum += boards[1][y+1][x]
	elseif x == 0	and y == 128 then
		sym += boards[1][y-1][x]
		sum += boards[1][y-1][x+1]
		sum += boards[1][y][x+1]
	elseif x == 128 and y == 0 then
		sum += boards[1][y][x-1]
		sum += boards[1][y+1][x-1]
		sum += boards[1][y+1][x]
	elseif x == 128 and y == 128 then
		sum += boards[1][y-1][x]
		sum += boards[1][y][x-1]
		sum += boards[1][y+1][x]
	elseif x == 0 then
		sum += boards[1][y][x+1]
		sum += boards[1][y-1][x+1]
		sum += boards[1][y+1][x+1]
		sum += boards[1][y+1][x]
		sum += boards[1][y-1][x]
	elseif x == 128 then
		sum += boards[1][y][x-1]
		sum += boards[1][y-1][x-1]
		sum += boards[1][y+1][x-1]
		sum += boards[1][y+1][x]
		sum += boards[1][y-1][x]
	elseif y == 0 then
		sum += boards[1][y][x-1]
		sum += boards[1][y][x+1]
		sum += boards[1][y+1][x-1]
		sum += boards[1][y+1][x]
	 sum += boards[1][y+1][x+1]
	elseif y == 128 then
		sum += boards[1][y][x-1]
		sum += boards[1][y][x+1]
		sum += boards[1][y-1][x-1]
		sum += boards[1][y-1][x]
	 sum += boards[1][y-1][x+1]
	else 
		sum += boards[1][y][x-1]
		sum += boards[1][y][x+1]
		sum += boards[1][y+1][x]
		sum += boards[1][y+1][x-1]
		sum += boards[1][y+1][x+1]
		sum += boards[1][y-1][x-1]
		sum += boards[1][y-1][x]
		sum += boards[1][y-1][x+1]
	end
	return sum
end	
