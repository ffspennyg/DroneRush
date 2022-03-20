Drone = Class{}

function Drone:init(skin)
    self.y = VIRTUAL_HEIGHT - 30
    self.x = VIRTUAL_WIDTH / 2 - 8

    self.height = 16
    self.width = 16

    self.dx = 0
    self.dy = 0

    self.skin = skin
end

function Drone:update(dt, projectiles)
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.dx = -DRONE_SPEED
    elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self.dx = DRONE_SPEED
    else
        self.dx = 0
    end

    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        self.dy = -DRONE_SPEED
    elseif love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        self.dy = DRONE_SPEED
    else
        self.dy = 0
    end

    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end

    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end

    if love.keyboard.wasPressed('space') then
        if Power.drone == true then
            table.insert(projectiles, Projectile(self.x + 4, self.y - PROJECTILE_LENGTH, 'up'))
            table.insert(projectiles, Projectile(self.x - 4, self.y - PROJECTILE_LENGTH, 'up'))
            table.insert(projectiles, Projectile(self.x, self.y - PROJECTILE_LENGTH, 'up'))
        else
            table.insert(projectiles, Projectile(self.x, self.y - PROJECTILE_LENGTH, 'up'))
        end
    end
end

function Drone:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    return true
end

function Drone:render()
    love.graphics.draw(gTextures['drones'], gFrames['drones'][1 + (self.skin - 1)],
    self.x, self.y)
end