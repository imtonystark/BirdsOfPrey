-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
--require("xml.lua")
--local xml = require( "xml" ).newParser()
--local network = require("gamedata")squareLength = math.min( display.contentWidth, display.contentHeight )
print("squareLength: "..squareLength)
insideSquareLength = squareLength / 8
-- init variables
local GRID_WIDTH = 8
local GRID_HEIGHT = 8
local CELL_WIDTH = 40
local CELL_HEIGHT = 40
local xPos
local yPos

local tableGame = {}
local grid = {}
for i = 1, GRID_HEIGHT do
grid[i] = { }
end
-- init functions 
local createPlayScreen
local moveShip
local fireTorp
-- preload sounds
local torpedoSound = audio.loadSound( "torpedo.mp3" )

local physics = require("physics")  -- init physics engine
physics.start()
physics.setGravity(0,0)

squareLength = math.min( display.contentWidth, display.contentHeight )
insideSquareLength = squareLength / 8
local function createPlayScreen()

---	background = display.newImageRect("grid.png",300,400)
----	background.x = display.contentCenterX
-----	background.y = display.contentCenterY

--   local gbOffsetX = background.x - (background.width * background.anchorX)
  -- local gbOffsetY = background.y - (background.height * background.anchorY)
squareLength = math.min( display.contentWidth, display.contentHeight )
insideSquareLength = squareLength / 8
for i = 1, 8 , 1 do
	--grid[i] = {}
	for j = 1, 8 , 1 do	
		square =  display.newRect(0,0, insideSquareLength , insideSquareLength)
		square.name = "square"
		if ( i + j ) % 2 == 0 then
			square.colorName =  "White"
			square.color = .2 -- setFillColor( gray )
			square:setFillColor( 249, 195, 136 )
			table.insert( whiteSquares, square )
		else
			square.colorName =  "Black"
			square.color = .8 -- setFillColor( gray )
			square:setFillColor( 191, 120, 48 )
			table.insert( blackSquares, square )
		end

		column = i
		row = j
		square.column = column
		square.row = row
		board[column][row] = square
		xIni = display.contentCenterX -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
		yIni = display.contentCenterY -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
		square.x = xIni + insideSquareLength * ( i - 1 )
		square.y = yIni + insideSquareLength * ( j - 1 )
		board[i][j] = square
	end
end
	
    ship = display.newImageRect("enterprise.png",CELL_WIDTH,CELL_HEIGHT)
	ship.x = display.contentCenterX
	ship.y = display.contentCenterY
	xPos = ship.x
	yPos = ship.y
	--ship.x = (xPos - 1) * CELL_WIDTH + (CELL_WIDTH * 0.5) + gbOffsetX
	--ship.y = (yPos - 1) * CELL_HEIGHT + (CELL_HEIGHT * 0.5) + gbOffsetY
	
	ship.alpha = 1
   -- grid[xPos][yPos] = ship
   
	
	physics.addBody( ship,"dynamic", { radius=30, isSensor=true } )
	
	
	title = display.newImageRect("title.png",400,60)
	title.x = display.contentCenterX + 10
	title.y = 0	
	
	
	
	end
	
	
 local function moveShip(event)
 
    local ship = event.target
    local phase = event.phase
 --if (event.name == "touch") then
    if ( "began" == phase ) then
        -- Set touch focus on the ship
        display.currentStage:setFocus( ship )
        -- Store initial offset position
        ship.touchOffsetX = event.x - ship.x
		ship.touchOffsetY = event.y - ship.y
 
    elseif ( "moved" == phase ) then
        -- Move the ship to the new touch position
        ship.x = event.x - ship.touchOffsetX
		ship.y = event.y - ship.touchOffsetY
  
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on the ship
       display.currentStage:setFocus( nil )
--	end 
    
 elseif (event.name == "tap") then
 -- get the screen x, y for where we are moving to
		--
		local x = (xPos - 1) * CELL_WIDTH + (CELL_WIDTH * 0.5) + gbOffsetX
local y = (yPos - 1) * CELL_HEIGHT + (CELL_HEIGHT * 0.5) + gbOffsetY
   grid [xPos][yPos] = ship
   transition.to(grid[yPos][xPos], { time = 500, x = x, y = y})
 
 end
  
    return true  -- Prevents touch propagation to underlying objects
	end
 
 local function fireTorp(event)
 background = event.target
 phase = event.phase
                                                                                                                                                          
 audio.play(torpedoSound)
 
 
 end

	-- Function to handle button events
local function handleTabBarEvent( event )
    print( event.target.id )  -- Reference to button's 'id' parameter
end
 
-- Configure the tab buttons to appear within the bar
local tabButtons = {
    {
        label = "Tab1",
        id = "tab1",
        selected = true,
        onPress = handleTabBarEvent
    },
    {
        label = "Tab2",
        id = "tab2",
        onPress = handleTabBarEvent
    },
    {
        label = "Tab3",
        id = "tab3",
        onPress = handleTabBarEvent
    }
}
 
-- Create the widget
--local tabBar = widget.newTabBar(
--    {
--        top = display.contentHeight-20,
 --       width = display.contentWidth,
--        buttons = tabButtons
--    }
--)

createPlayScreen()
 ship:addEventListener( "touch", moveShip ) -- begin event listener!
 background:addEventListener("tap", moveShip)
 --background:addEventListener("tap", fireTorp)
 