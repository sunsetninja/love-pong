local push = require("push")

local gameWidth = 432
local gameHeight = 243

-- size of our actual window
local windowWidth = 1280
local windowHeight = 720

local paddleSpeed = 200

function getTrueColor(color)
  return color / 255
end

function getTrueSpeed(speed, dt)
  return speed * dt
end

-- Initial love function
function love.load()
  -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text 
  -- and graphics
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- game fonts
  local smallFont = love.graphics.newFont('font.ttf', 8)
  local scoreFont = love.graphics.newFont('font.ttf', 32)

  love.graphics.setFont(smallFont)
  
  push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  playerOneScore = 0
  playerTwoScore = 0

  playerOneY = 30
  playerTwoY = gameHeight - 50
end

-- Main loop function
function love.update(dt)
  -- Players movements
  if (love.keyboard.isDown('w') and playerOneY > 0) then
    playerOneY = playerOneY - getTrueSpeed(paddleSpeed, dt)
  elseif (love.keyboard.isDown('s') and playerOneY < gameHeight - 20) then
    playerOneY = playerOneY + getTrueSpeed(paddleSpeed, dt)
  end


  if (love.keyboard.isDown('up') and playerTwoY > 0) then
    playerTwoY = playerTwoY - getTrueSpeed(paddleSpeed, dt)
  elseif (love.keyboard.isDown('down') and playerTwoY < gameHeight - 20) then
    playerTwoY = playerTwoY + getTrueSpeed(paddleSpeed, dt)
  end
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
    love.graphics.rectangle('fill', 10, playerOneY, 5, 20)

    -- render second paddle (right side)
    love.graphics.rectangle('fill', gameWidth - 10, playerTwoY, 5, 20)

    -- render ball (center)
    love.graphics.rectangle('fill', gameWidth / 2 - 2, gameHeight / 2 - 2, 4, 4)

    -- end rendering at virtual resolution
    push:apply('end')
end