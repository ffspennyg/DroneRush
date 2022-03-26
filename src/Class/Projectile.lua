Projectile = Class{}

function Projectile:init(x, y, direction)
    self.image = love.graphics.newImage('graphics/projectile.png')

    self.x = x
    self.y = y

    self.width = 4
    self.height = 4

    self.direction = direction
end

function Projectile:update(dt)
    if self.direction == 'up' then
        self.y = self.y - PROJECTILE_SPEED * dt
    else
        self.y = self.y + PROJECTILE_SPEED * dt
    end
end

function Projectile:collides(rock)
    if self.x > rock.x + rock.width or self.x + self.width < rock.x or
        self.y > rock.y + rock.height or self.y + self.height < rock.y then
            return false
    else
        return true
    end
end

function Projectile:render()
    if self.y > 0 then
        love.graphics.draw(self.image, self.x + 6, self.y - 4)
    end
end