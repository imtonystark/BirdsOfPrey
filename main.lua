-----------------------------------------------------------------------------------------
-- Birds of Prey : An adaptation of the 1970's Classic "Super Star Trek"
-- Code by : Jesse L Blum
-- 
-- Revised : 2/8/2017
-----------------------------------------------------------------------------------------

math.randomseed(os.time())
local widget = require("widget")
require("stardates")
require("klingons")
require("sysMsg")
require("globals")
require("starfield")
-- experimental for resolution
    _H   = math.floor( display.actualContentHeight + 0.5 )
    _W  = math.floor( display.actualContentWidth + 0.5 )
--
-- init variables
--local GRID_WIDTH = 8
--local GRID_HEIGHT = 8
--local CELL_WIDTH = 40
--local CELL_HEIGHT = 40
_G.MAX_KLINGONS = 40
--local MAX_SECTOR_KLINGONS = 8
--local MAX_STARBASE = 8
--local BAR_HEIGHT = 1
--local BAR_WIDTH = 1
local phasers = false
local photons = false
local catbutton = 0 
--_G.klingonsRemaining = _G.MAX_KLINGONS
turnCounter = 1
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


-- init stardates

initStarDate()

--
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
local klingonHitSound= audio.loadSound("largeexplosion2.mp3")
local themeSong = audio.loadSound("theme.mp3")

------------------------------------------------------------------------------
-- Init Physics engine
------------------------------------------------------------------------------
local physics = require("physics")  
physics.start()
physics.setGravity(0,0)
------------------------------------------------------------------------------
------------------------------------------------------------------------------

squareLength = math.min( _W*.80, _H*.80)
insideSquareLength = squareLength / 8

local function createPlayScreen()

	displayGroup = display.newGroup()
	frame = display.newImageRect( displayGroup,"frame.png", _W, _H )
	frame.x = _W/2
	frame.y = _H/2
	gametileborder = display.newRoundedRect(displayGroup, frame.x,frame.y,squareLength*1.02,squareLength*1.02,10)
	gametileborder.strokeWidth=1.5
	gametileborder:setFillColor(0)
	gametileborder:setStrokeColor(0,0.63,.62,1.00)

	local id = 1
		for i = 1, 8 , 1 do
	
			for j = 1, 8 , 1 do	
	
				square =  display.newImageRect(displayGroup,"backtile.png", insideSquareLength , insideSquareLength )
				square.name = "square"
				square:addEventListener("tap",jumpShip)


			column = i
			row = j
			square.column = column
			square.row = row
			grid[column][row] = square
			xIni = display.contentCenterX -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
			yIni = display.contentCenterY -  ( insideSquareLength * 8 ) / 2 + insideSquareLength / 2
			square.x = xIni + insideSquareLength * ( i - 1 )
			square.y = yIni + insideSquareLength * ( j - 1 )
			grid[i][j] = square
			sector = 1
				if (temp[sector][i][j] ==  1 ) then
					local cloaked = math.random(1,2)
					 
					klingons[id] = display.newImageRect(displayGroup,"klingon.png",insideSquareLength,insideSquareLength)
					klingons[id].x = square.x
					klingons[id].y = square.y
					klingons[id].gridXY = {i,j}
					klingons[id].alpha = 1
					--physics.addBody(klingons,"dynamic",{radius=25, isSensor=true})
					physics.addBody(klingons[id],"dynamic",{radius=10,  density = 3})
					klingons[id].name = "klingon"
					klingons[id].id = id
					klingons[id].damage = 10
					if cloaked == 1 then
						klingons[id].cloaked = true
						klingons[id].alpha = 0.01
					else
						klingons[id].cloaked = false
						klingons[id].alpha = 1
					end
					klingons[id].active = false
					klingons[id].collision = objcollision
					klingons[id]:addEventListener("collision",klingons[id])
					id=id+1
	
	
					
			end
			
	end

end
	
    ship = display.newImageRect(displayGroup,"enterprise.png",insideSquareLength,insideSquareLength)
	ship.x = display.contentCenterX
	ship.y = display.contentCenterY
	xPos = ship.x
	yPos = ship.y

	
	ship.alpha = 1
	ship.name = "enterprise"
	ship.shields = false
	ship.collision = enterpriseDamage
	physics.addBody( ship,"static", { radius=20, density = 3.0 } )

	ship:addEventListener("collision", ship)

	
menuBtn1 = widget.newButton {displayGroup, font = "ArcadeClassic.TTF",label = "Nav", height = _H*.05, width = _W* .175, defaultFile="buttonnormal.png", overFile="buttonpressed.png",onRelease = function() menuSelects(1,0) catbutton = 1 end}
menuBtn2 = widget.newButton {displayGroup, font = "ArcadeClassic.TTF",label = "Tac", height = _H*.05, width = _W* .175, defaultFile="buttonnormal.png", overFile="buttonpressed.png",onRelease = function() weaponsActive = true menuSelects(2,0) catbutton = 2 end}
menuBtn3 = widget.newButton {displayGroup, font = "ArcadeClassic.TTF",label = "Sen", height = _H*.05, width = _W* .175, defaultFile="buttonnormal.png", overFile="buttonpressed.png",onRelease = function() menuSelects(3,0) catbutton = 3 end}
menuBtn4 = widget.newButton {displayGroup, font = "ArcadeClassic.TTF",label = "Com", height = _H*.05, width = _W* .175, defaultFile="buttonnormal.png", overFile="buttonpressed.png",onRelease = function() menuSelects(4,0) catbutton = 4 end}
menuBtn1.x = _W * .80
menuBtn1.y = _H * .80
menuBtn1:rotate(90)
menuBtn1._view._label.size = 30

menuBtn2.x = _W * .80
menuBtn2.y = _H * .90
menuBtn2:rotate(90)
menuBtn2._view._label.size = 30

menuBtn3.x = _W * .70
menuBtn3.y = _H * .80
menuBtn3:rotate(90)
menuBtn3._view._label.size = 30

menuBtn4.x = _W * .70
menuBtn4.y = _H * .90
menuBtn4:rotate(90)
menuBtn4._view._label.size = 30

btn1 = widget.newButton {displayGroup,font = "ArcadeClassic.TTF",label = "Impulse", height = _H*.05, width = _W*.20,defaultFile ="buttonnormal.png", overFile = "buttonpressed.png",onRelease = function()if btn1.myName == "Phasers" then weaponsActive = true phasers = true end if btn1.myName == "Impulse" then weaponsActive = false end end}
btn1.x = _W * .60
btn1.y = _H * .85
btn1.myName = "Impulse"
btn1:rotate(90)
btn1._view._label.size = 30

btn2 = widget.newButton {displayGroup,font = "ArcadeClassic.TTF",label = "Warp", height = _H*.05, width = _W*.20,defaultFile ="buttonnormal.png", overFile = "buttonpressed.png",onRelease = function() if btn2.myName == "Torp" then weaponsActive = true photons = true phasers = false end end}
btn2.x = _W * .50
btn2.y = _H * .85
btn2.myName ="Warp"
btn2:rotate(90)
btn2._view._label.size = 30

btn3 = widget.newButton {displayGroup,font = "ArcadeClassic.TTF",label = "Thrusters", height = _H*.05, width = _W*.20,defaultFile ="buttonnormal.png", overFile = "buttonpressed.png",onRelease = function() if btn3.myName == "Shields" then setShields(ship,ship.x,ship.y) end end}
btn3.x = _W * .40
btn3.y = _H * .85
btn3.myName="Thrusters"
btn3:rotate(90)
btn3._view._label.size = 30

displayClock((_W *.20),(_H*.85))


statusBar("Weapons",_W *.83 ,_H *.15,"redstatusbar.png",90)
statusBar("Shields",_W *.61,_H *.15,"yellowstatusbar.png",90)
statusBar("Engines",_W *.39,_H *.15,"bluestatusbar.png",90)
statusBar("Reserves",_W *.17,_H *.15,"greenstatusbar.png",90)

systemMessage(1,_W*.5,_H*.5,550,200,event)
end
	
function moveKlingons(self,event,temp)
local north
local east
local south
local west

id = self.id
print(id)

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
	
	jumpX = klingons[id].x + (jumpTable[jump][1]*insideSquareLength)
	jumpY = klingons[id].y + (jumpTable[jump][2]*insideSquareLength)
	local check = checkMove(self,event,jumpTable[jump][1],jumpTable[jump][2]) 
	if (check == true) then

	transition.to(klingons[id], {time = 500, delay = 1000,x=(jumpX),y=(jumpY)})
	klingons[id].gridXY[1] = klingons[id].gridXY[1] + jumpTable[jump][1]
		klingons[id].gridXY[2] = klingons[id].gridXY[2] + jumpTable[jump][2]
    klingons[id]:toFront()
	klingonAttack(id,event)

	

end
	end




--end
end

function spawnKlingons()
local numOfKlingons = math.random(1,MAX_KLINGONS)
local numOfStarBase = math.random(1,MAX_STARBASE)
local availKlingons = numOfKlingons
local availStarBase = numOfStarBase
while (availKlingons > 0) do
for i = 1, _G.MAX_KLINGONS do 
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
	btn1.myName = "Impulse"
	btn2:setLabel("Warp")
	btn2.myName = "Warp"
	btn3:setLabel("Thrusters")
	btn3.myName = "Thrusters"
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

function setShields(ship,x,y)

if ship.shields == false then 
ship.shields = true

else

end
end

function firePhaser(event)

   
--	audio.play(phasersSound)
	angle = compassGrid(ship.x,ship.y,event.target.x,event.target.y)
	transition.to( ship, { rotation=angle, time=750, transition=easing.inOutCubic } )
	local distance = math.sqrt((ship.x - event.target.x)^2 + (ship.y - event.target.y)^2)
	local mid = midPoint(ship.x,ship.y,event.target.x,event.target.y)
	
timer.performWithDelay(750,	function() local newPhaser = display.newRect(displayGroup,mid[1],mid[2], distance, 2)
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
	audio.play(phasersSound)
	 end)
	
	
end

  
 function jumpShip(event)
 setClock(newClock.x,newClock.y)
 if weaponsActive == true then
 if phasers == true then
 firePhaser(event)
 elseif photons == true then
 fireTorp(event)
 end
 else
 
 local pointShip = compassGrid(ship.x,ship.y,event.target.x,event.target.y)
 transition.to( ship, { rotation=pointShip, time=500, transition=easing.inOutCubic } )
 transition.moveTo( ship, { rotation = pointShip, time = 2000,x= event.target.x, y=event.target.y})
 
 audio.play(enginesSound)
end 
turnCounter = turnCounter + 1
end

 function fireTorp(event)
	local angle = compassGrid(ship.x,ship.y,event.target.x,event.target.y)
 transition.to( ship, { rotation=angle, time=750, transition=easing.inOutCubic } )
 timer.performWithDelay(750,function()  local newTorp = display.newImageRect("torp.png",10,10)
   physics.addBody( newTorp, { density=3.0, friction=0.5, bounce=0.3 } )
    newTorp.isBullet = true
	--newTorp:setLinearVelocity( 1000, 1000 )
    newTorp.name="torp"
	newTorp.x = ship.x
	newTorp.y = ship.y
	transition.to( newTorp, {x=event.target.x,y=event.target.y, time=500, onComplete= function() display.remove(newTorp) end  } ) 
 
 audio.play(torpedoSound) end)
 
 end
 
 

 function objcollision(self,event)
 local target
 local weapon 
 local loss = calcDamage(event)
 if (event.phase == "began") then
 print(self.name)
 print(event.other.name)
 if(event.other.name == "enterprise") then
 for i = 0,10 do
 system.vibrate()
 end
 print("VIBRATE!")
 end
if self.name == "klingon" then



	if (self.damage == 10) then
	if self.cloaked == true then 
	    klingons[self.id].cloaked=false
		klingons[self.id].alpha = 1
	end
	transition.blink(self, {alpha = 1})
	audio.stopWithDelay(500)
	audio.play(klingonHitSound)
	self.active = true
	--klingonAttack(self.id,event)
	end

	if self.damage <= 0 then
   display.remove(self)
   _G.klingonsRemaining = _G.klingonsRemaining - 1
   end
   audio.stopWithDelay(750)
	audio.play(klingonHitSound)
	self.damage=self.damage - loss
	moveKlingons(self,event,temp)
	
	


	end
	end

end
	function enterpriseDamage(self,event)
	if (event.phase == "began") then
	if self.name == "enterprise"  and event.other.name == "Torp" then
	display.remove(event.other)
	audio.play(klingonHitSound)
	--transition.blink(self, {alpha =1, time = 1000})
	end
	end
end
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
local barLabel = display.newText(tostring(barid), x + (_W*.10), y, "ArcadeClassic.TTF", 24)
barLabel:setFillColor(  0.72, 0.9, 0.16, 0.78 )
barLabel.rotation = 90

statusbar = display.newImageRect("statusbox.png",  BAR_WIDTH * (_W*.30),  BAR_HEIGHT * (_H*.10))
statusbar.x = x
statusbar.y= y
statusbar.name = barid
statusbar.rotation = rot
local spacer = 0 
for i = 1, 8 do

levelBar = display.newImageRect(tostring(col),  (statusbar.contentWidth * .80), (statusbar.contentHeight * .80)/8)
levelBar.name = barid
levelBar.x = statusbar.x 
levelBar.y = (statusbar.y - statusbar.contentHeight/2 - 10) + ((statusbar.contentHeight/8)-1) * i


end

end

function checkMove(self,event,toX,toY)

local toXY = {toX,toY}
print("ship position : ", self.gridXY[1],",",self.gridXY[2])
print("target postition : ", toX,",",toY)
if self.gridXY[1]+toX > 8 or self.gridXY[2]+toY > 8 then
print("Out of Range!!")
return false
end
if self.gridXY[1]+toX<=0 or self.gridXY[2]+toY<=0 then 
print("Out of Range!!")
return false
end
return true
end




function calcDamage(event)
local effect = math.random(1,10)

if (event.other == "torp") then
self.damage = self.damage - effect
elseif (event.other.name == "Phasers") then 
local distance = math.sqrt((ship.x - event.target.x)^2 + (ship.y - event.target.y)^2) 
self.damage = self.damage - (effect - distance)
end
return effect
end

function fireDisrupter(id,event)
    Torp = display.newImageRect("torp.png",10,10)
    --physics.addBody( Torp, { density=3.0, friction=0.5, bounce=0.3, isBullet=true, isSensor = true } )
    Torp.isBullet = true
	
    Torp.name="torp"
	Torp.x = klingons[id].x
	Torp.y = klingons[id].y
	Torp.velocity = 1000
	transition.to( Torp, {x=ship.x,y=ship.y, time=500, onComplete= function() display.remove(Torp) end  } )
 
 audio.play(torpedoSound)
 
 end
 

--function splashScreen()
audio.play(themeSong)
local splashGroup = display.newGroup()

splash = display.newImageRect(splashGroup,"starfield.png",_W,_H)
splash.x = _W/2
splash.y = _H/2
--testing autoscale code snippet
local scale = math.max(_W / splash.width, _H / splash.height)
splash:scale(scale, scale)
--end snippet 
--display title
--local title = display.newImageRect( "birdsofprey.png",340,200)
local title1 = display.newText(splashGroup,"Birds Of Prey",(_W/2),_H*.75, "FINALOLD.TTF",175)
title1.x = display.contentCenterX 
title1.y = _H /4
title1:setFillColor(1,1,0,1.00)

local title2 = display.newText(splashGroup,"An adaptation of the MicroComputer\n classic - Super Star Trek",title1.x,_H*.35,"FINALOLD.TTF",45)
--title2.x = title1.x
--title2.y = title2.y + 20
title2.align = "center"
title2:setFillColor(1,1,0,1.00)


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
enterprise.x = _W * .99 + 200
enterprise.y = _H *.5

klingon = display.newImageRect(splashGroup,"sideviewklingon.png", 80, 80)
klingon.x = display.contentCenterX + 50
klingon.y = display.contentCenterY + 175
klingon.alpha = 0

transition.to(enterprise, { x = _W *.01 - 200, y = _H * .5, delay = 10000, time = 10000 } )
--transition.to(klingon, {alpha = .2, time = 10000})
--transition.to(klingon, {alpha = .0, time = 11000})
--transition.to(klingon, {alpha = .4, time = 12000})
--transition.to(klingon, {alpha = .0, time = 13000})
--transition.to(klingon, {alpha = 1, delay = 12500, time = 7000})
transition.to(klingon, {alpha = 1, rotation = 90, delay = 11500, time = 6500, onComplete = function()transition.to(klingon,{delay = 750,x= _W *.01 -300, y = _H *.5,time = 1000}) end} )

enterprise2 = display.newImageRect(splashGroup,"pixelncc1701.png",150,100)
enterprise2.x = _W * .01 - 200
enterprise2.y = _H * .5

klingon2 = display.newImageRect(splashGroup,"sideviewklingon.png", 80, 80)
klingon2.x = _W * .01 - 200
klingon2.y = _H * .05
klingon2.rotation = 180
klingon2.alpha = 1

transition.to(enterprise2, {x = _W *.99 + 300, y =_H *.5 +40, delay = 40000, time = 2750})

transition.to(klingon2, {x = _W *.99 + 300, y = _H *.5 + 40, delay = 41000, time = 2750 } )

transition.to(enterprise2, {x = _W *.01 - 300, y = _H *.5 - 75, delay = 45000, time = 2750 })

transition.to(klingon2, {x = _W *.01 - 300, y = _H * .5 - 75, delay = 46000, time = 2750 } )


klingon3 = display.newImageRect(splashGroup,"sideviewklingon.png", 80, 80)
klingon3.x = display.contentCenterX + 120
klingon3.y = display.contentCenterY + 0
klingon3.rotation = 0
klingon3.alpha= 0
transition.to(klingon3, {
alpha=1,delay = 25000, time = 2500 , 
onComplete = function() transition.to(klingon3,{delay = 500, alpha = 0, time=1500})  

 local displayTorp = display.newImageRect("disrupter.png",10,30)
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



local displayTorp = display.newImageRect("disrupter.png",10,30)
local displayTorp2 = display.newImageRect("disrupter.png",10,30)
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
local flag = true
-- Standard text object
function stopAnim(event)
flag = false

end
function scrolltext(event)
if flag == true then
local scrolling = display.newText(splashGroup,"TAP  ANYWHERE  TO  BEGIN !!!     ...", 50, 50, "ArcadeClassic.ttf", 38 )
scrolling.x = _W * .99 + 300
scrolling.y = _H *.85
scrolling.alpha=1 

scrolling:setFillColor( 0.72, 0.9, 0.16, 0.78)
scrolling:toFront()
transition.to(scrolling, {x=_W * .01 - 300,y=_H*.85, time = 8500, delay = 0})
--transition.blink(scrolling, {time=3000})
end
return true
end 
timer.performWithDelay(3800,scrolltext,-1)
splash:addEventListener("tap",function()stopAnim(event) transition.cancel() display.remove(splashGroup) audio.stop() spawnKlingons() createPlayScreen() display.remove(startBtn) display.remove(title) return true end)
--startBtn = widget.newButton {splashGroup,label = "START!", height = 50,width = 100, defaultFile ="buttonnormal.png", overfile = "buttonpressed.png", onRelease = function()stopAnim(event) transition.cancel() display.remove(splashGroup) audio.stop() spawnKlingons() createPlayScreen() display.remove(startBtn) display.remove(title) return true end}
--startBtn.rotate = 90
--startBtn.x = display.contentCenterX
--startBtn.y = display.contentCenterY + 500


