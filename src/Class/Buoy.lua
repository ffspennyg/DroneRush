Buoy = Class{}

function Buoy:init()
    self.tier = math.random(4)

    self.x = math.random(VIRTUAL_WIDTH - 6)
    self.y = - 32

    self.height = 14
    self.width = 16

    self.remove = false
end

function Buoy:update(dt)
    if self.y < VIRTUAL_HEIGHT then
        self.y = self.y + BUOY_SPEED * dt
    else
        self.remove = true
    end
end

function Buoy:hit(crabs)
    if self.tier >= 1 then
        table.insert(crabs, Crab(self.x, self.y))
        table.insert(crabs, Crab(self.x, self.y))
        if self.tier == 1 then
            self.remove = true
        else
            self.tier = self.tier - 1
        end
    end
end

function Buoy:render()
    if self.remove == false then
        love.graphics.draw(gTextures['world2'], gFrames['buoys'][1 + (self.tier - 1)],
        self.x, self.y)
    end
end