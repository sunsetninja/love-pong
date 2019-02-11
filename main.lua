-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Initial love function
function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })
end

function love.draw()
  love.graphics.printf(
    'What a nice pong goes here!',
    0,
    WINDOW_HEIGHT / 2 - 6,
    WINDOW_WIDTH,
    'center'
  )
end