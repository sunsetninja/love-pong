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

  -- game fonts
  local smallFont = love.graphics.newFont('font.ttf', 8)

  love.graphics.setFont(smallFont)
  
  push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })
end

--[[
    Keyboard handling, called by LÖVE2D each frame; 
    passes in the key we pressed so we can access.
]]
function love.keypressed(key)
  -- keys can be accessed by string name
  if key == 'escape' then
      -- function LÖVE gives us to terminate application
      love.event.quit()
  end
end

--[[
    Called after update by LÖVE2D, used to draw anything to the screen, 
    updated or otherwise.
]]
function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    -- using virtual width and height now for text placement
    love.graphics.printf('Hello Pong!', 0, gameHeight / 2 - 6, gameWidth, 'center')

    -- end rendering at virtual resolution
    push:apply('end')
end