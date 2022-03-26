Lives = Class{}

function Lives:init()
    self.image = love.graphics.newImage('graphics/droneHealth.png')
    self.y = 16
    self.x = VIRTUAL_WIDTH - 36

    self.height = 16
    self.width = 16
end

function Lives:render()
    love.graphics.draw(self.image, self.x, self.y)
end