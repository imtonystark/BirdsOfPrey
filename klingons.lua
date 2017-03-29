------------------------------------------------------------------------------
-- klingons.lua 
-- Klingon warbird Behaviors and attack patterns
-- Code By : Jesse L Blum
--
-- Last Revised : 2/11/2017
------------------------------------------------------------------------------
--local physics = require("physics")  -- init physics engine
--physics.start()
--physics.setGravity(0,0)

function klingonAttack(id,event)

if id >= 0 then

local val = math.random(1,8)
if val >= 1 or val <7 then 
fireDisrupter(id,event)



end
end

end