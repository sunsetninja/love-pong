local push = require("push")

local gameWidth = 432
local gameHeight = 243

-- size of our actual window
local windowWidth = 1280
local windowHeight = 720

-- Initial love function
function love.load()
  -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text 
  -- and graphics
  love.graphics.setDefaultFilter('nearest', 'nearest')
  
    push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })
end

function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    -- using virtual width and height now for text placement
    love.graphics.printf('Hello Pong!', 0, gameHeight / 2 - 6, gameWidth, 'center')

    -- end rendering at virtual resolution
    push:apply('end')
end