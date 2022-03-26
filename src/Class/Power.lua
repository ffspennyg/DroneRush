Power = Class{}

function Power:init(x, y)
    self.x = x
    self.y = y

    self.height = 12
    self.width = 12

    self.remove = false
end

function Power:update(dt)
    if self.y < VIRTUAL_HEIGHT then
        self.y = self.y + 30 * dt
    else
        self.remove = true
    end
end

function Power:activate()
    if math.random(2) == 1 then
        self.drone = true
    else
        self.health = true
    end
end

function Power:deactivate()
    self.drone = false
end

function Power:render()
    if self.remove == false then
        love.graphics.draw(gTextures['powers'], gFrames['power'][1], self.x, self.y)
    end
end