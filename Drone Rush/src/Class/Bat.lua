Bat = Class{}

function Bat:init()
    self.x = math.random(211)
    self.y = -16

    self.dx = math.random(-100, 100)
    self.dy = math.random(-50, 50)

    self.width = 12
    self.height = 6

    self.tier = 1

    self.remove = false
end

function Bat:update(dt)
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

function Bat:hit()
    self.remove = true
end

function Bat:render()
    if self.remove == false then
        love.graphics.draw(gTextures['bugs'], gFrames['bat'][self.tier],
        self.x, self.y)
    end
end