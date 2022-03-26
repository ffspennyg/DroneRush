Crab = Class{}

function Crab:init(x, y)
    self.x = x
    self.y = y

    self.dx = math.random(-150, 150)

    self.width = 8
    self.height = 6

    self.tier = math.random(4)

    self.remove = false
end

function Crab:update(dt)
    if self.y < VIRTUAL_HEIGHT then
        self.x = self.x + self.dx * dt
        self.y = self.y + CRAB_SPEED * dt
    else
        self.remove = true
    end

    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
    end

    if self.x >= VIRTUAL_WIDTH - 8 then
        self.x = VIRTUAL_WIDTH - 8
        self.dx = -self.dx
    end
end

function Crab:hit()
    self.dx = -self.dx

    if self.tier <= 4 then
        if self.tier == 1 then
            self.remove = true
        else
            self.tier = self.tier - 1
        end
    end
end

function Crab:render()
    if self.remove == false then
        love.graphics.draw(gTextures['world2'], gFrames['crabs'][1 + (self.tier - 1)],
        self.x + 4, self.y + 2)
    end
end