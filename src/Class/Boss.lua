Boss = Class{}

function Boss:init()
    self.x = VIRTUAL_WIDTH / 2 - 25
    self.y = - 50

    self.dx = 150

    self.height = BOSS_HEIGHT
    self.width = BOSS_WIDTH

    self.remove = false

    self.Health = 50
end

function Boss:update(dt)
    if self.y < 30 then
        self.y = self.y + BOSS_SPEED * dt
    end

    if self.x <= 0 then
        self.x = 0
        self.dx = -self.dx
    end

    if self.x >= VIRTUAL_WIDTH - 50 then
        self.x = VIRTUAL_WIDTH - 50
        self.dx = -self.dx
    end
end

function Boss:hit()
    self.Health = self.Health - 1
    if self.Health == 0 then
        self.remove = true
    end
end