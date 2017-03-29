------------------------------------------------------------------------------
-- Stardates.lua 
-- Code by: Jesse L Blum
-- Revised: 2/10/2017
------------------------------------------------------------------------------
local globals = require("globals")
-- BEGINDATE = 2801
--local ENDDATE 
local STARDATE
local level = 100
math.randomseed(os.time())

function initStarDate()
local val = math.random(level,300)
STARDATE = BEGIN_DATE
--_G.BEGIN_DATE = BEGINDATE -- update globals
END_DATE = BEGIN_DATE + val 
--END_DATE = ENDDATE -- update globals
--turnCounter = 1
--return STARDATE
end

function displayClock(x,y)
local thousand = math.floor((STARDATE / 1000))
local hundred = math.floor((STARDATE % 1000) *.01)
local ten = math.floor((STARDATE % 100) *.1)
local one = (STARDATE % 10) 
local tenth = 0
local timeUnits = { thousand, hundred , ten , one , tenth }
local ending = END_DATE - STARDATE
newClock = display.newText("", 100, 100, "ArcadeClassic.TTF", 32)
newClock.text = string.format( "        STAR DATE \n            %u %u %u %u.%u   \n\n    End   Mission    \n                  %u	", thousand, hundred, ten, one, tenth,ending )
newClock.x = x
newClock.y = y
newClock.rotation=90
newClock.alpha=0
transition.to(newClock,{alpha = 1, time = 175})
turnCounter = turnCounter + 1
end

function setClock(x,y)
STARDATE = STARDATE + 1
transition.to(newClock,{alpha=0,time=175})
displayClock(x,y)
end