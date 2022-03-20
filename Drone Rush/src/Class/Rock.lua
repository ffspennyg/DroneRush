Rock = Class{}

function Rock:init()
    self.tier = math.random(4)

    self.x = math.random(VIRTUAL_WIDTH - 16)
    self.y = - 32

    self.height = ROCK_HEIGHT
    self.width = ROCK_WIDTH

    self.remove = false
end

function Rock:update(dt)
    if self.y < VIRTUAL_HEIGHT then
        self.y = self.y + ROCK_SPEED * dt
    else
        self.remove = true
    end
end

function Rock:hit(bugs, powers)
    if self.tier <= 3 then
        table.insert(bugs, Bug(self.x, self.y))
        table.insert(bugs, Bug(self.x, self.y))
        if self.tier == 3 then
            self.remove = true
            if math.random(5) == 1 then
                table.insert(powers, Power(self.x, self.y))
            end
        else
            self.tier = self.tier + 1
        end
    end
end

function Rock:render()
    if self.remove == false then
        love.graphics.draw(gTextures['main'], gFrames['rock'][self.tier],
        self.x, self.y)
    end
end