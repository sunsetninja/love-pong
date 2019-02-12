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

  -- random seed for a ball movements
  math.randomseed(os.time())

  -- game fonts
  smallFont = love.graphics.newFont('font.ttf', 8)
  scoreFont = love.graphics.newFont('font.ttf', 32)

  gameTitle = 'Love pong'
  
  push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  playerOneScore = 0
  playerTwoScore = 0

  -- initial positions
  ballX = gameWidth / 2 - 2
  ballY = gameHeight / 2 - 2

  playerOneY = 30
  playerTwoY = gameHeight - 50

  -- velocity
  -- 50% chanse to move left or right
  ballDX = math.random(2) == 1 and 100 or -100
  -- random angle
  ballDY = math.random(-50, 50)

  -- game state
  gameState = 'start'
end

-- Main loop function
function love.update(dt)
  -- Players movements
  if love.keyboard.isDown('w') then
    playerOneY = math.max(0, playerOneY - getTrueSpeed(paddleSpeed, dt))
  elseif (love.keyboard.isDown('s')) then
    playerOneY = math.min(gameHeight - 20, playerOneY + getTrueSpeed(paddleSpeed, dt))
  end


  if love.keyboard.isDown('up') then
    playerTwoY = math.max(0, playerTwoY - getTrueSpeed(paddleSpeed, dt))
  elseif love.keyboard.isDown('down') then
    playerTwoY = math.min(gameHeight - 20, playerTwoY + getTrueSpeed(paddleSpeed, dt))
  end

  if gameState == 'play' then
    ballX = ballX + getTrueSpeed(ballDX, dt)
    ballY = ballY + getTrueSpeed(ballDY, dt)
    gameTitle = 'Good luck'
  elseif gameState == 'start' then
    gameTitle = 'Love pong'
  end
end

--[[
    Keyboard handling, called by LÖVE2D each frame; 
    passes in the key we pressed so we can access.
]]
function love.keypressed(key)
  -- keys can be accessed by string name
  if key == 'escape' then
      -- terminate game
      love.event.quit()
  elseif key == 'space' then
    if gameState == 'start' then
      gameState = 'play'
    elseif gameState == 'play' then
      gameState = 'start'

      ballX = gameWidth / 2 - 2
      ballY = gameHeight / 2 - 2

      ballDX = math.random(2) == 1 and 100 or -100
      ballDY = math.random(-50, 50) * 1.5
    end
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
    
    -- draw a title
    love.graphics.setFont(smallFont)

    -- using virtual width and height now for text placement
    love.graphics.printf(gameTitle, 0, 20, gameWidth, 'center')

    -- draw players scores
    love.graphics.setFont(scoreFont)

    love.graphics.print(
      tostring(playerOneScore),
      gameWidth / 2 - 50,
      gameHeight / 3
    )

    love.graphics.print(
      tostring(playerTwoScore),
      gameWidth / 2 + 30,
      gameHeight / 3
    )

    -- render first paddle (left side)
    love.graphics.rectangle('fill', 10, playerOneY, 5, 20)

    -- render second paddle (right side)
    love.graphics.rectangle('fill', gameWidth - 10, playerTwoY, 5, 20)

    -- render ball (center)
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    -- end rendering at virtual resolution
    push:apply('end')
end