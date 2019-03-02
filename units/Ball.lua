Ball = Class{}

function Ball:init(x, y, width, height)
  self.x = x
  self.y = y

  self.width = width
  self.height = height

  self.dx = math.random(2) == 1 and 100 or -100
  self.dy = math.random(-50, 50)
end

function Ball:update(dt)
  self.x = self.x + getTrueSpeed(self.dx, dt)
  self.y = self.y + getTrueSpeed(self.dy, dt)
end

function Ball:reset()
  self.x = gameWidth / 2 - self.width
  self.y = gameHeight / 2 - self.height

  self.dx = math.random(2) == 1 and 100 or -100
  self.dy = math.random(-50, 50)
end

function Ball:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
      return false
    end

    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
      return false
    end 

    return true
end

function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end