--
-- For more information on config.lua see the Corona SDK Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings

--calculate the aspect ratio of the device:

local aspectRatio = display.pixelHeight / display.pixelWidth
application = { 
  content = {
      width = aspectRatio > 1.5 and 800 or math.floor( 1200 / aspectRatio ),
      height = aspectRatio < 1.5 and 1200 or math.floor( 800 * aspectRatio ),
      scale = "letterBox",
      fps = 30,
        xAlign = "left",
		yAlign = "top",
 
      imageSuffix = {
         ["@2x"] = 1.3,
      },
   },
}
