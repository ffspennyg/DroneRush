Lava = Class{}

function Lava:init()
    self.x = math.random(VIRTUAL_WIDTH - 16)
    self.y = - 32

    self.height = 16
    self.width = 16

    self.remove = false
end

function Lava:update(dt)
    if self.y < VIRTUAL_HEIGHT then
        self.y = self.y + 30 * dt
    else
        self.remove = true
    end
end

function Lava:render()
    if self.remove == false then
        love.graphics.draw(gTextures['world3'], gFrames['lava'][1],
        self.x, self.y)
    end
end