function getTrueColor(color)
  return color / 255
end

function getTrueSpeed(speed, dt)
  return speed * dt
end

function displayFPS()
  love.graphics.setFont(smallFont)
  love.graphics.setColor(0, 1, 0, 1)

  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end