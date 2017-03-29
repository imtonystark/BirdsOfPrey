-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
--require("xml.lua")
system.setTapDelay(2)
math.randomseed(os.time())
local widget = require("widget")
--local xml = require( "xml" ).newParser()
--local network = require("gamedata")squareLength = math.min( display.contentWidth, display.contentHeight )
--print("squareLength: "..squareLength)
--insideSquareLength = squareLength / 8
-- init variables
local GRID_WIDTH = 8
local GRID_HEIGHT = 8
local CELL_WIDTH = 30
local CELL_HEIGHT = 30
local MAX_KLINGONS = 40
local MAX_SECTOR_KLINGONS = 8
local MAX_STARBASE = 8
local phasers = false
local photons = false
local catbutton = 0 

local square
local menutable= {}
local xPos
local yPos
local weaponsActive
local tableGame = {}
local sector
local grid = {}
klingons = { }
-- init aray for klingons and starbases
gamePieces = {}

temp = { } -- temp table

-- inserting all the height levels
for h=1, 8 do table.insert( temp , { } ) end

-- inserting all the lengths
for h=1, 8 do
    for l=1, 8 do table.insert( temp[h], { } ) end
end

-- inserting all the width and defaulting them to 0
for h=1, 8 do
    for l=1, 8 do
        for w=1, 8 do table.insert( temp[h][l] , 0 ) end
    end
end




for i = 1, GRID_HEIGHT do
grid[i] = { }
end
-- init functions 
local createPlayScreen
local setWeapons
local moveShip
local fireTorp
-- preload sounds
local torpedoSound = audio.loadSound( "torpedo.mp3" )
local enginesSound = audio.loadSound("engines.mp3")
local phasersSound = audio.loadSound("phaser.mp3")
local themeSong = audio.loadSound("theme.mp3")
local physics = require("physics")  -- init physics engine
physics.start()
physics.setGravity(0,0)

squareLength = math.min( display.contentWidth - CELL_WIDTH*2, display.contentHeight - CELL_HEIGHT*2)
insideSquareLength = squareLength / 8
local function createPlayScreen()


displayGroup = display.newGroup()
--frame = display.newImageRect( displayGroup,"frame.png", display.contentWidth, display.contentHeight )
--frame.x = display.contentWidth/2
--frame.y = display.contentHeight/2
--gametileborder = display.newRoundedRect(frame.x,frame.y,squareLength+10,squareLength+10,10)
--gametileborder.strokeWidth=1
--gametileborder:setFillColor(0)
--gametileborder:setStrokeColor(0,.37,1)
--gametileborder:setStrokeColor(0,0.63,.62,1.00)
local id = 1
for i = 1, 8 , 1 do
	--grid[i] = {}
	for j = 1, 8 , 1 do	
	
		square =  display.newImageRect("backtile.png", insideSquareLength, insideSquareLength)
		--square.name = "square"
		--physics.addBody(square, "dynamic", {radius = 5})
		square:toFront()
		square:addEventListener("tap",jumpShip)
		--


		column = i
		row = j
		square.column = column
		square.row = row
	--	grid[column][row] = square
		xIni = display.contentCenterX -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
		yIni = display.contentCenterY -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
		square.x = xIni + insideSquareLength * ( i - 1 )
		square.y = yIni + insideSquareLength * ( j - 1 )
	--	grid[i][j] = square
		sector = 1
		if (temp[sector][i][j] ==  1 ) then
		
			-- display klingon 
			klingons[id] = display.newImageRect("klingon.png",insideSquareLength,insideSquareLength)
			klingons[id].x = square.x
			klingons[id].y = square.y
			klingons[id].alpha = 1
			--physics.addBody(klingons,"dynamic",{radius=25, isSensor=true})
			physics.addBody(klingons[id],"dynamic",{bounce = 0.3,radius=10})
			klingons[id].name = "klingon"
			klingons[id].id = id
			klingons[id].damage = 10
			klingons[id].cloaked = false
			klingons[id].active = false
			klingons[id].collision = objcollision
			--title = display.newImageRect("title.png",400,60)
			--title.x = display.contentCenterX + 10
			--title.y = 0	
			klingons[id]:addEventListener("collision",klingons[id])
			klingons[id]:toFront()
			id=id+1
			end
	
	end

end

	
    ship = display.newImageRect("enterprise.png",insideSquareLength,insideSquareLength)
	ship.x = display.contentCenterX
	ship.y = display.contentCenterY
	xPos = ship.x
	yPos = ship.y

	
	ship.alpha = 1
	ship.name = "enterprise"

   
	
	--physics.addBody( ship,"static", { radius=20, isSensor=false } )

	

	
menuBtn1 = widget.newButton {displayGroup, label = "Nav", height = 50, width = 50, defaultFile="buttonnormal.png", overFile="buttonpressed.png",onRelease = function() menuSelects(1,0) catbutton = 1 end}
menuBtn2 = widget.newButton {displayGroup, label = "Tac", height = 50, width = 50, defaultFile="buttonnormal.png", overFile="buttonpressed.png",onRelease = function() weaponsActive = true menuSelects(2,0) catbutton = 2 end}
menuBtn3 = widget.newButton {displayGroup, label = "Sen", height = 50, width = 50, defaultFile="buttonnormal.png", overFile="buttonpressed.png",onRelease = function() menuSelects(3,0) catbutton = 3 end}
menuBtn4 = widget.newButton {displayGroup, label = "Com", height = 50, width = 50, defaultFile="buttonnormal.png", overFile="buttonpressed.png",onRelease = function() menuSelects(4,0) catbutton = 4 end}
menuBtn1.x = display.contentCenterX + 100
menuBtn1.y = display.contentCenterY + 505
menuBtn1:rotate(90)

menuBtn2.x = display.contentCenterX + 100
menuBtn2.y = display.contentCenterY + 555
menuBtn2:rotate(90)

menuBtn3.x = display.contentCenterX + 50
menuBtn3.y = display.contentCenterY + 505
menuBtn3:rotate(90)

menuBtn4.x = display.contentCenterX + 50
menuBtn4.y = display.contentCenterY + 555
menuBtn4:rotate(90)

btn1 = widget.newButton {displayGroup,label = "Impulse", height = 50, width = 100,defaultFile ="buttonnormal.png", overFile = "buttonpressed.png",onRelease = function()if btn1.myName == "Phasers" then weaponsActive = true phasers = true end end}
btn1.x = display.contentCenterX 
btn1.y = display.contentCenterY + 530
btn1:rotate(90)

btn2 = widget.newButton {displayGroup,label = "Warp", height = 50, width = 100,defaultFile ="buttonnormal.png", overFile = "buttonpressed.png",onRelease = function() if btn2.myName == "Torp" then weaponsActive = true photons = true phasers = false end end}
btn2.x = display.contentCenterX - 50
btn2.y = display.contentCenterY + 530
btn2:rotate(90)

btn3 = widget.newButton {displayGroup,label = "Thrusters", height = 50, width = 100,defaultFile ="buttonnormal.png", overFile = "buttonpressed.png",onRelease = setWeapons}
btn3.x = display.contentCenterX - 100
btn3.y = display.contentCenterY + 530
btn3:rotate(90)

statusBar("Weapons",280,90,"redstatusbar.png",90)
statusBar("Shields",210,90,"yellowstatusbar.png",90)
statusBar("Engines",140,90,"bluestatusbar.png",90)
statusBar("Reserves",70,90,"greenstatusbar.png",90)



	end
--Runtime:addEventListener("tap",jumpShip)
function moveKlingons(self,event,temp)
local north
local east
local south
local west
--local northeast
--local northwest
--local southeast
--local southwest

id = self.id
print(id)
--for i = 1, 8 do
--for j = 1, 8 do
--if temp[sector][i][j] == 1 then
local sector = 1
print("sector ", sector)
local x=klingons[id].x
print(x)
local y=klingons[id].y
print(y)

	if klingons[id].active == true then 
	print ("Klingon #", id , " active!")
	--	if temp[sector][x][y] and temp[sector][x][y-1] and temp[sector][x][y+1] == 0 then
	--	north = true 
	--	if ((temp[sector][x][y-1]) + (temp[sector][x][y]) + (temp[sector][x][y-1]) == 0) then
	--	east = true
	--	west = true
	--	end
	--	if temp[sector][x+1][y-1] + temp[sector][x+1][y] + temp[sector][x+1][y+1] == 0 then
	--	south = true
	local jumpTable = {{-1,1} , {0,-1} , {1,-1},
					  {-1,0} ,          {1,0},       --- skip 0,0
					  {-1,1} , {0,1} , {1,1}}
	math.randomseed(os.time())
	local jump = math.random(1,8)
	
	local jumpX
	local jumpY
	--for i = 1,8 do
	
	jumpX = klingons[id].x + (jumpTable[jump][1]*CELL_WIDTH)
	jumpY = klingons[id].y + (jumpTable[jump][2]*CELL_HEIGHT)
	
	transition.to(klingons[id], {time = 500, delay = 1000,x=(jumpX-CELL_WIDTH),y=(jumpY+CELL_HEIGHT)})
    klingons[id]:toFront()





end
end

function spawnKlingons()
local numOfKlingons = math.random(1,MAX_KLINGONS)
local numOfStarBase = math.random(1,MAX_STARBASE)
local availKlingons = numOfKlingons
local availStarBase = numOfStarBase
while (availKlingons > 0) do
for i = 1, MAX_KLINGONS do 
sector = math.random(1,8)
if (totalEnemies(sector) < 8) then
local newCoOrd = posRandomXY()
x = newCoOrd[1]
y = newCoOrd[2]
temp[sector][x][y] = 1
availKlingons = availKlingons - 1
end
end
end

end

function posRandomXY()
local randomXY = {}

randomXY[1]= math.random(1,8)
randomXY[2]= math.random(1,8)

return randomXY

end
function totalEnemies(sector)
local total = 0
for i = 1, 8 do
for j = 1, 8 do 
total = total + temp[sector][i][j] 
end
end
return total
end

function menuSelects(atbutton,button)
	if atbutton == 1 and button == 0 then
	btn1:setLabel("Impulse")
	btn2:setLabel("Warp")
	btn3:setLabel("Thrusters")
	--if catbutton == 1 and button == 1 then 
	
	elseif atbutton == 2 and button == 0 then 
	btn1:setLabel("Phasers")
	btn1.myName = "Phasers"
	btn2:setLabel("Torpedos")
	btn2.myName = "Torp"
	btn3:setLabel("Shields")
	btn3.myName = "Shields"
	
	elseif atbutton == 3 and button == 0 then
	btn1:setLabel("Scan")
	btn2:setLabel(" ")
	btn3:setLabel(" ")
	elseif atbutton == 4 and button == 0 then
	btn1:setLabel("Subspace")
	btn2:setLabel("Ship-to-Ship")
	btn3:setLabel("Distress")

	end
	
	
end
function firePhaser(event)

    --local newPhaser = display.newImageRect("phaser.png")
		audio.play(phasersSound)
	angle = compassGrid(ship.x,ship.y,event.target.x,event.target.y)
	local distance = math.sqrt((ship.x - event.target.x)^2 + (ship.y - event.target.y)^2)
	local mid = midPoint(ship.x,ship.y,event.target.x,event.target.y)
	--local newPhaser = display.newLine(displayGroup, ship.x,ship.y,event.target.x,event.target.y)
	local newPhaser = display.newRect(displayGroup,mid[1],mid[2], distance, 2)
	--newPhaser.x = ship.x
	--newPhaser.y = ship.y
	newPhaser:setStrokeColor(0,.5,.5,1)
	newPhaser.strokeWidth = 1.5
    physics.addBody( newPhaser, { density=3.0,friction=0.5 } )
	--physics.addBody( newPhaser, { density=3.0, friction=0.5, bounce=0.3 } )
	--newPhaser:setLinearVelocity( 1000, 1000 )
    --newPhaser.isBullet = true
    newPhaser.name= "Phaser"
	newPhaser.alpha=0
	newPhaser.rotation = angle
	transition.to( newPhaser, {time = 1000, alpha=1, onComplete = function()  display.remove(newPhaser) end })
	
	
end

  function moveShip(event)

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
 function jumpShip(event)

 if weaponsActive == true then
 if phasers == true then
 firePhaser(event)
 elseif photons == true then
 fireTorp(event)
 end
 else
 --transition.to(ship,event.x,event.y)
 --if (event.numTaps == 1 and tab1.selected == true) then
 --fireTorp(event)
 --elseif
 --event.numTaps == 1 then
 local pointShip = compassGrid(ship.x,ship.y,event.target.x,event.target.y)
 --ship.rotation = pointShip
 transition.to( ship, { rotation=pointShip, time=500, transition=easing.inOutCubic } )
 transition.moveTo( ship, { rotation = pointShip, time = 2000,x= event.target.x, y=event.target.y})
 
 audio.play(enginesSound)
end 


return true
end
 function fireTorp(event)

   local newTorp = display.newImageRect("torp.png",10,10)
   physics.addBody( newTorp, { density=3.0, friction=0.5, bounce=0.3 } )
    newTorp.isBullet = true  
    newTorp.name="torp"
	newTorp.x = ship.x
	newTorp.y = ship.y
	transition.to( newTorp, {x=event.target.x,y=event.target.y, time=500, onComplete= function() display.remove(newTorp) end  } )
 
 audio.play(torpedoSound)
 
 end
 
 

 function objcollision(self,event)
 local target
 local weapon 
 local loss = calcDamage(event)
 if (event.phase == "began") then
 print(self.name)
 print(event.other.name)
if self.name == "klingon" then
	if (self.damage == 10) then
	transition.blink(self)
	self.active = true
	end
	--self.damage = self.damage - loss
	if self.damage <= 0 then
   display.remove(self)
   end
	self.damage=self.damage - loss
	moveKlingons(self,event,temp)
	end
	end
	end
--Runtime:addEventListener("collision",objcollision)

function compassGrid(x,y,x2,y2)
local degrees
local currentX=x
local currentY=y
local destY=y2
local destX=x2


  local degrees = ( math.deg( math.atan2( y2-y, x2-x ) )+180 )
   if ( degrees < 0 ) then degrees = degrees + 360 end
   return degrees % 360

end
function midPoint(x1,y1,x2,y2)
local val = {}
val[1]= ((x1+x2)/(2))
val[2]= ((y1+y2)/(2))
return val
end
function setWeapons(event)
		


end

function statusBar(barid,x,y,col,rot)
local barLabel = display.newText(tostring(barid), x + 32, y, native.systemFontBold, 15 )
barLabel:setFillColor(  0.72, 0.9, 0.16, 0.78 )
barLabel.rotation = 90

statusbar = display.newImageRect("statusbox.png",  102,  50)
statusbar.x = x
statusbar.y= y
statusbar.name = barid
statusbar.rotation = rot
local spacer = 0 
for i = 1, 8 do

levelBar = display.newImageRect(tostring(col),  40, 10)
levelBar.name = barid
levelBar.x = statusbar.x 
levelBar.y = (statusbar.y - 42) + spacer
spacer = spacer + 12

end

end

function calcDamage(event)
local effect = math.random(1,10)

if (event.other == "torp") then
self.damage = self.damage - effect
elseif (event.other.name == "Phasers") then 
local distance = math.sqrt((ship.x - event.target.x)^2 + (ship.y - event.target.y)^2) 
self.damage = self.damage - (effect - distance)
--event.target.damage = event.target.damage - effect

end
return effect
end


--function splashScreen()
audio.play(themeSong)
splash = display.newImageRect("starfield.png",display.contentWidth,display.contentHeight)
splash.x = display.contentWidth/2
splash.y = display.contentHeight/2
--testing autoscale code snippet
local scale = math.max(display.contentWidth / splash.width, display.contentHeight / splash.height)
splash:scale(scale, scale)
--end snippet 
--display title
local title = display.newImageRect( "birdsofprey.png",340,200)
title.x = display.contentCenterX 
title.y = display.contentHeight /4

local splashGroup = display.newGroup()
splashGroup:insert( splash )
splashGroup:insert( title )



--optionlist2 = {x=splashGroup.contentCenterX, y = display.contentCenterY + 40, time = 10000,alpha=0}

--one = display.newText( "   Birds Of Prey - 2017", display.contentCenterX,(display.contentCenterY + 100),300,300,native.systemFont, 16)
--transition.to(one,optionlist2)
--two = display.newText( "\n      Jesse L Blum     ",display.contentCenterX, (display.contentCenterY + 100),300,300,native.systemFont, 16)
--transition.to(two,optionlist2)
--three = display.newText( "\n\n*********************",display.contentCenterX, (display.contentCenterY + 100),300,300,native.systemFont, 16)
--transition.to(three,optionlist2)
--four = display.newText( "\n\n\nInspiration and game concepts",display.contentCenterX, (display.contentCenterY + 100),300,300,native.systemFont, 16)
--transition.to(four,optionlist2)
--five = display.newText( "\n\n\n\n based on Super Star Trek source",display.contentCenterX, (display.contentCenterY + 100),300,300,native.systemFont, 16)
--transition.to(five,optionlist2)
--six = display.newText( "\n\n\n\n\n published in 1976 by D. Ahl",display.contentCenterX, (display.contentCenterY + 100),300,300,native.systemFont, 16)
--transition.to(six,optionlist2)



--for i = 1,6 do


--transition.to(i,{x=splashGroup.contentCenterX, y = display.contentCenterY + 40, time = 10000,})
--transition.to(i,{x=splashGroup.contentCenterX, y=display.contentCenterY, time = 5000, alpha=0}) 

--end


--end title

--btn1 = widget.newButton {displayGroup,label = "Weapons", height = 50, width = 100,defaultFile ="buttonnormal.png", overFile = "buttonpressed.png"}
flag = false

---begin animation

enterprise = display.newImageRect(splashGroup,"pixelncc1701.png",150,100)
enterprise.x = display.contentCenterX + 300
enterprise.y = display.contentCenterY + 40 

klingon = display.newImageRect(splashGroup,"sideviewklingon.png", 80, 80)
klingon.x = display.contentCenterX + 50
klingon.y = display.contentCenterY + 175
klingon.alpha = 0

transition.to(enterprise, { x = display.contentCenterX - 300, y = display.contentCenterY + 40, delay = 10000, time = 10000 } )
--transition.to(klingon, {alpha = .2, time = 10000})
--transition.to(klingon, {alpha = .0, time = 11000})
--transition.to(klingon, {alpha = .4, time = 12000})
--transition.to(klingon, {alpha = .0, time = 13000})
--transition.to(klingon, {alpha = 1, delay = 12500, time = 7000})
transition.to(klingon, {alpha = 1, rotation = 90, delay = 11500, time = 6500, onComplete = function()transition.to(klingon,{delay = 750,x= display.contentCenterX -300, y = display.contentCenterY +40,time = 1000}) end} )

enterprise2 = display.newImageRect(splashGroup,"pixelncc1701.png",150,100)
enterprise2.x = display.contentCenterX -300
enterprise2.y = display.contentCenterY + 40 

klingon2 = display.newImageRect(splashGroup,"sideviewklingon.png", 80, 80)
klingon2.x = display.contentCenterX - 300 
klingon2.y = display.contentCenterY + 40
klingon2.rotation = 180
klingon2.alpha = 1

transition.to(enterprise2, {x = display.contentCenterX + 300, y =display.contentCenterY +40, delay = 40000, time = 2750})

transition.to(klingon2, {x = display.contentCenterX + 300, y = display.contentCenterY + 40, delay = 41000, time = 2750 } )

transition.to(enterprise2, {x = display.contentCenterX - 300, y =display.contentCenterY +75, delay = 45000, time = 2750 })

transition.to(klingon2, {x = display.contentCenterX - 300, y = display.contentCenterY + 75, delay = 46000, time = 2750 } )


klingon3 = display.newImageRect(splashGroup,"sideviewklingon.png", 80, 80)
klingon3.x = display.contentCenterX + 120
klingon3.y = display.contentCenterY + 0
klingon3.rotation = 0
klingon3.alpha= 0
transition.to(klingon3, {
alpha=1,delay = 25000, time = 2500 , 
onComplete = function() transition.to(klingon3,{delay = 500, alpha = 0, time=1500})  

 local displayTorp = display.newImageRect(splashGroup,"disrupter.png",10,30)
	displayTorp.x = klingon3.x + 5 
	displayTorp.y = klingon3.y + 5
	transition.to( displayTorp, {x=klingon3.x - 100,y=klingon3.y + 160, time=500, onComplete= function() display.remove(displayTorp) end  } )
	
end 
} )

klingon4 = display.newImageRect(splashGroup,"sideviewklingon.png", 80, 80)
klingon4.x = display.contentCenterX -120
klingon4.y = display.contentCenterY + 220
klingon4.rotation = 180
klingon4.alpha= 0
transition.to(klingon4, {
alpha=1,delay = 30000, time = 2500 ,
onComplete = function() transition.to(klingon4,{delay = 500, alpha = 0, time=1500})



local displayTorp = display.newImageRect(splashGroup,"disrupter.png",10,30)
local displayTorp2 = display.newImageRect(splashGroup,"disrupter.png",10,30)
	displayTorp.x = klingon4.x + 10
	displayTorp.y = klingon4.y + 50
	displayTorp.rotation = 45
	displayTorp2.x =klingon4.x  
	displayTorp2.y =klingon4.y - 50
	displayTorp2.rotation = 45
	transition.to( displayTorp, {x=displayTorp.x+100,y=displayTorp.y-100, time=500, onComplete= function() display.remove(displayTorp) end  } )
	transition.to( displayTorp2, {x=displayTorp.x+100,y=displayTorp.y-100, time=500, onComplete= function() display.remove(displayTorp2) end  } )

end } )

-- end animation 



startBtn = widget.newButton {label = "START!", height = 50,width = 100, defaultFile ="buttonnormal.png", overfile = "buttonpressed.png", onRelease = function() transition.cancel() audio.stop() spawnKlingons() createPlayScreen() display.remove(startBtn) display.remove(splashGroup) flag = true end}
startBtn.rotate = 90
startBtn.x = display.contentCenterX
startBtn.y = display.contentCenterY + 300

--spawnKlingons()
--end


--createPlayScreen()

 --ship:addEventListener( "touch", moveShip ) -- begin event listener!
