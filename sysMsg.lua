------------------------------------------------------------------------------
-- sysMsg.lua
-- Code By: Jesse L Blum
-- Revised 2/10/2017
------------------------------------------------------------------------------
local keySound =audio.loadSound("keysound.wav")
local MSGTABLE = {}
local globals = require("globals")
s = "	"
MSGTABLE = {" ".. s .. "STARFLEET COMMAND PRIORITY MESSAGE 		 \n" ..
			"-----------------------------------------------------------\n" ..       
			"Your orders are as follows : \n\n" ..
			"	Destroy the " .. tostring(_G.klingonsRemaining) .. " Klingon Warships which have invaded" ..
			"the galaxy before they can attack Federation headquarters " ..
			"on stardate ".. tostring(END_DATE) .. ". This gives you ".. tostring(0) .." days. There are ".. tostring(MAX_STARBASE) .." starbases" ..
			"in the galaxy for resupplying your ship."}, 
			{ }, 
			{ }
count = 0
                                                                      
function systemMessage(msgIndex,x,y,height,width,event)
local boxImage = io.open("msgBox.png","r")
if (boxImage) then

msgBox = display.newImageRect("msgBox.png", height, width)
msgBox.x = x
msgBox.y = y
msgBox.rotation = 90
else
msgBox = display.newRoundedRect(x,y,width,height,10)
msgBox.strokeWidth=1.5
msgBox:setFillColor(0)
msgBox:setStrokeColor(0,0.63,.62,1.00)
end
--msgBox.Tap = display.remove(msgBox)
local msgText = display.newText({
   text = "",
   font = "ArcadeClassic.ttf",
   fontSize = 18,
   width = height *.85,
   height = width *.85,
   align = "left"
})
msgText.x = msgBox.x 
msgText.y = msgBox.y 
msgText.rotation = 90

local textString = MSGTABLE[msgIndex]

local typewriterFunction = function(event)
   msgText.text = string.sub(textString .. "  ", 1, event.count)
   audio.play(keySound)
end
local typewriterTimer = timer.performWithDelay(50, typewriterFunction, string.len(textString))
msgBox:addEventListener("tap",function()display.remove(msgBox)display.remove(msgText) audio.stop() timer.cancel(typewriterTimer) end)

end