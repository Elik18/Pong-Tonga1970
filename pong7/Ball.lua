require 'class'
require 'Paddle'
Ball = class()

function Ball:collides(Paddle)
    if self.x > Paddle.width + Paddle.x or Paddle.x > self.x + self.width then
        return false
    end

    if self.y > Paddle.height + Paddle.y or Paddle.y > self.y + self.height then
        return false
    end

    return true
    
    
end
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2- 2
    self.y = VIRTUAL_HEIGHT / 2- 2
    self.dx =math.random(-50,50)
    self.dy = math.random(2) == 1 and -100 or 100
    
end


function Ball:init(x,y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dy = math.random(2) == 1 and 100 or -100
    self.dx = math.random(-50,50)
end

function Ball:update(dt)

    self.x = self.x + self.dx * dt
    self.y = self.y +  self.dy * dt


end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height )
end