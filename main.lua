local push = require("libs/push")
Class = require('libs/class')

require('utils')

-- units
require('units/Paddle')
require('units/Ball')

gameWidth = 432
gameHeight = 243

-- size of our actual window
local windowWidth = 1280
local windowHeight = 720

local paddleSpeed = 200

-- Initial love function
function love.load()
  love.window.setTitle('Love pong')

  -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text 
  -- and graphics
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- random seed for a ball movements
  math.randomseed(os.time())

  -- game fonts
  smallFont = love.graphics.newFont('assets/font.ttf', 8)
  scoreFont = love.graphics.newFont('assets/font.ttf', 32)

  gameTitle = 'Love pong'
  
  push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  playerOneScore = 0
  playerTwoScore = 0

  -- initial positions
  playerOne = Paddle(10, 30, 5, 20)
  playerTwo = Paddle(gameWidth - 15, gameHeight - 30, 5, 20)

  ball = Ball(gameWidth / 2 - 2, gameHeight / 2 - 2, 4, 4)

  -- game state
  gameState = 'start'
end

-- Main loop function
function love.update(dt)
  if gameState == 'play' then
    if ball:collides(playerOne) then
        ball.dx = -ball.dx * 1.03
        ball.x = playerOne.x + playerOne.width

        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    end
    
    if ball:collides(playerTwo) then
        ball.dx = -ball.dx * 1.03
        ball.x = playerTwo.x - ball.width

        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    end

    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
    end

    if ball.y >= gameHeight - 4 then
        ball.y = gameHeight - 4
        ball.dy = -ball.dy
    end

    -- Score update
    if ball.x < 0 then
      servingPlayer = 1
      playerTwoScore = playerTwoScore + 1
      ball:reset()
      gameState = 'serve'
    end
    
    if ball.x > gameWidth then
      servingPlayer = 2
      playerOneScore = playerOneScore + 1
      ball:reset()
      gameState = 'serve'
    end
  end
  
  -- Players movements
  if love.keyboard.isDown('w') then
    playerOne.dy = -paddleSpeed
  elseif (love.keyboard.isDown('s')) then
    playerOne.dy = paddleSpeed
  else
    playerOne.dy = 0
  end

  if love.keyboard.isDown('up') then
    playerTwo.dy = -paddleSpeed
  elseif love.keyboard.isDown('down') then
    playerTwo.dy = paddleSpeed
  else
    playerTwo.dy = 0
  end

  if gameState == 'play' then
    gameTitle = 'Good luck'
    ball:update(dt)
  elseif gameState == 'start' then
    gameTitle = 'Love pong'
  end

  playerOne:update(dt)
  playerTwo:update(dt)
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

      ball:reset()
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
      1
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

    -- render paddles
    playerOne:render()
    playerTwo:render()

    -- render ball
    ball:render()

    displayFPS()

    -- end rendering at virtual resolution
    push:apply('end')
end