local push = require("push")

local gameWidth = 432
local gameHeight = 243

-- size of our actual window
local windowWidth = 1280
local windowHeight = 720

function getTrueColor(color)
  return color / 255
end

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

    -- fill background with original pong background color
    love.graphics.clear(
      getTrueColor(40),
      getTrueColor(45),
      getTrueColor(52),
      255
    )

    -- using virtual width and height now for text placement
    love.graphics.printf('Love Pong', 0, 20, gameWidth, 'center')

    --
    -- paddles are simply rectangles we draw on the screen at certain points,
    -- as is the ball
    --

    -- render first paddle (left side)
    love.graphics.rectangle('fill', 10, gameHeight / 2 - 10, 5, 20)

    -- render second paddle (right side)
    love.graphics.rectangle('fill', gameWidth - 10, gameHeight / 2 - 10, 5, 20)

    -- render ball (center)
    love.graphics.rectangle('fill', gameWidth / 2 - 2, gameHeight / 2 - 2, 4, 4)

    -- end rendering at virtual resolution
    push:apply('end')
end