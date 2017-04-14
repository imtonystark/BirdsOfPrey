------------------------------------------------------------------------------
-- Starfield.lua
-- code By: Jesse L Blum, with portions from and inspired by some common
--          example programs tutorials found in the wild.
-- Revised: 2/18/2017
------------------------------------------------------------------------------
local num_stars = 250
local max_depth = 100
local stars = {}
local drawStar = {}
local originX
local originY
math.randomseed(os.time())


--function starfield()


--end
 
for i = 1, num_stars do
stars[i] = {(math.random(-25,25)),(math.random(-25,25)),(math.random(1,max_depth))}
--drawStar[i]={}
end


--end

function moveAndDraw (event)
for index = 1, num_stars do
-------------------------------------------------------
-- define origin point
-------------------------------------------------------
originX = display.contentWidth /2
originY = display.contentHeight /2
--------
-- end
--------

stars[index][3] = stars[index][3] - 0.75		-- reduce Z by .19 each frame

-------------------------------------------------------
-- If star has moved off screen, move the star
-------------------------------------------------------

if (stars[index][3] <= 0) then
                stars[index][1] = math.random(-25,25)
                stars[index][2] = math.random(-25,25)
                stars[index][3] = max_depth
				--display.remove(drawStar[index])
				
end


-------------------------------------------------------
-- Convert 3d co-ordinates to 2D coordinates
-------------------------------------------------------

            k = 128.0 / stars[index][3]
            x = (stars[index][1] * k + originX)
            y = (stars[index][2] * k + originY)

-----------
-- end
-----------

-------------------------------------------------------
-- Size and shade stars
-------------------------------------------------------

--if ((0 <= x) and (0 < display.contentWidth)) and ((0 <= y) and (0 < display.contentHeight)) then
if (0<=x) and (0 <=y) then 
              local size = (1-stars[index][3] / max_depth) * 5
			  
--if ((max_depth*.50)<= x) and ((max_depth*.50)<= y) then
--			local size = (1-stars[index][3] / max_depth) * 6
              shade = stars[index][3]
			  print(shade)
             --   self.screen.fill((shade,shade,shade),(x,y,size,size))
--end 

-----------
 
-----------

-------------------------------------------------------
-- Draw stars
-------------------------------------------------------
--drawStar = { }
if (drawStar[index]) == nil  then

drawStar[index] = display.newRect(x,y,size,size)
--drawStar[index].alpha = shade
else
display.remove(drawStar[index])
drawStar[index] = display.newRect(x,y,size,size)
drawStar:setFillColor(shade,shade,shade)
--drawStar[index].alpha = shade
end
end
end
end
--starfield()
--for i=1, 50 do
--timer.performWithDelay(.00001,moveAndDraw,-1)
--end
