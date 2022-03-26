Jelly = Class{}

function Jelly:init(x, y)
    self.x = x
    self.y = y

    self.dx = math.random(-100, 100)
    self.dy = math.random(-50, 50)

    self.width = 6
    self.height = 6

    self.tier = math.random(4)

    self.remove = false
end

function Jelly:update(dt)
    if self.y < VIRTUAL_HEIGHT then
        self.y = self.y + self.dy * dt
        self.x = self.x + self.dx * dt
    else
        self.remove = true
    end

    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
    end

    if self.x >= VIRTUAL_WIDTH - 6 then
        self.x = VIRTUAL_WIDTH - 6
        self.dx = -self.dx
    end

    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
    end
end

function Jelly:hit()
    self.dx = -self.dx
    self.dy = -self.dy

    if self.tier <= 4 then
        if self.tier == 1 then
            self.remove = true
        else
            self.tier = self.tier - 1
        end
    end
end

function Jelly:render()
    if self.remove == false then
        love.graphics.draw(gTextures['bugs'], gFrames['jelly'][self.tier],
        self.x, self.y)
    end
end