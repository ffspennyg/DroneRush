Turtle = Class()

function Turtle:init()
    self.tier = math.random(2)

    self.x = VIRTUAL_WIDTH + 5
    self.y = math.random(VIRTUAL_HEIGHT / 3)

    self.height = 16
    self.width = 32

    self.remove = false
end

function Turtle:update(dt)
    if self.y < VIRTUAL_HEIGHT then
        if self.x > 0 then
            self.y = self.y + TURTLE_SPEED * dt
            self.x = self.x - TURTLE_SPEED * dt
        else
            self.remove = true
        end
    end
end

function Turtle:hit(powers)
    if self.tier <= 2 then
        if self.tier == 1 then
            self.remove = true
            if math.random(5) == 1 then
                table.insert(powers, Power(self.x, self.y))
            end
        else
            self.tier = self.tier - 1
        end
    end
end

function Turtle:render()
    if self.remove == false then
        love.graphics.draw(gTextures['world2'], gFrames['turtle'][self.tier],
        self.x, self.y)
    end
end