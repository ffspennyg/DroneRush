World3State = Class {__includes = BaseState}

function World3State:enter(params)
    self.highScores = params.highScores
    self.score = params.score

    self.drone = params.drone
    self.projectiles = {}

    self.lava = Lava()
    self.lavas = {}

    self.snake = Snake()
    self.snakes = {}

    self.bat = Bat()
    self.bats = {}

    self.lizard = Lizard()
    self.lizards = {}

    self.power = Power()
    self.powers = {}
    self.powerTimer = 0

    self.health = params.health
    self.lives = params.lives
    self.recovery = params.recovery

    self.spawnTimer = 0
    self.timer = 0
    
    self.level = params.level
    self.world = params.world
    self.round = params.round
end

function World3State:update(dt)
    if scrolling then
		background_y = (background_y + background_spd * dt) % BACKGROUND_LOOPING_POINT
    end

    self.drone:update(dt, self.projectiles)

    self.timer = self.timer + dt
    self.powerTimer = self.powerTimer + dt
    self.spawnTimer = self.spawnTimer + dt

    if self.spawnTimer > 1 then

        table.insert(self.lavas, Lava())
        table.insert(self.bats, Bat())
 
        self.spawnTimer = 0

        if math.random(2) == 1 then
            table.insert(self.snakes, Snake())
            self.spawnTimer = 0

        else
            table.insert(self.lizards, Lizard())
            self.spawnTimer = 0
        end
    end

    if self:checkVictory() then
        gStateMachine:change('victory', {
            level = self.level,
            score = self.score,
            highScores = self.highScores,
            drone = self.drone,
            lives = self.lives,
            health = self.health,
            recovery = self.recovery,
            world = self.world,
            round = self.round
        })
    end

    for p_key, projectile in pairs(self.projectiles) do
        projectile:update(dt)

        if projectile.y <= -PROJECTILE_LENGTH or projectile.y > VIRTUAL_HEIGHT then
            self.projectiles[p_key] = nil
        else
            for a_key, snake in pairs(self.snakes) do
                if projectile:collides(snake) then
                    snake:hit(self.powers)
                    self.score = self.score + 5 * snake.tier
                    self.projectiles[p_key] = nil
                end
            end

            for a_key, lizard in pairs(self.lizards) do
                if projectile:collides(lizard) then
                    lizard:hit(self.powers)
                    self.score = self.score + 5 * lizard.tier
                    self.projectiles[p_key] = nil
                end
            end

            for a_key, lava in pairs(self.lavas) do
                if projectile:collides(lava) then
                    self.projectiles[p_key] = nil
                end
            end

            for a_key, bat in pairs(self.bats) do
                if projectile:collides(bat) then
                    bat:hit()
                    self.score = self.score + 2 * bat.tier
                    self.projectiles[p_key] = nil
                end
            end
        end
    end

    for k, power in pairs(self.powers) do
        power:update(dt)
        if self.drone:collides(power) then
            power.remove = true
            Power:activate()
            if power.health == true then
                self.health = self.health + 1
                self.score = self.score + 500
            end

            self.powerTimer = 0
        end
    end

    if self.powerTimer >= 5 then
        Power:deactivate()
    end

    for k, snake in pairs(self.snakes) do
        snake:update(dt)
        if self.drone:collides(snake) then
            snake.remove = true
            self.health = self.health - 1
            self.score = self.score - 500

            if self.health == 0 then
                gStateMachine:change('game-over', {
                    score = self.score,
                    highScores = self.highScores,
                    world = self.world
                })
            end
        end
    end

    for k, bat in pairs(self.bats) do
        bat:update(dt)
        if self.drone:collides(bat) then
            bat.remove = true
            self.health = self.health - 1
            self.score = self.score - 500

            if self.health == 0 then
                gStateMachine:change('game-over', {
                    score = self.score,
                    highScores = self.highScores,
                    world = self.world
                })
            end
        end
    end

    for k, lizard in pairs(self.lizards) do
        lizard:update(dt)
        if self.drone:collides(lizard) then
            lizard.remove = true
            self.health = self.health - 1
            self.score = self.score - 500

            if self.health == 0 then
                gStateMachine:change('game-over', {
                    score = self.score,
                    highScores = self.highScores,
                    world = self.world
                })
            end
        end
    end

    for k, lava in pairs(self.lavas) do
        lava:update(dt)
        if not lava.scored then
            if self.drone.y + self.drone.height < lava.y then
                self.score = self.score + 7
                lava.scored = true
                if self.score > self.recovery then
                    if self.health < 2 then
                        self.health = 2
                    end
                    self.recovery = self.score + (self.score / 2)
                else
                    return
                end
            end
        end

        if self.drone:collides(lava) then
            lava.remove = true
            self.health = self.health - 1
            self.score = self.score - 500

            if self.health == 0 then
                gStateMachine:change('game-over', {
                    score = self.score,
                    highScores = self.highScores,
                    world = self.world
                })
            end
        end
    end

    for k, lava in pairs(self.lavas) do
        if lava.remove then
            table.remove(self.lavas, k)
        end
    end

    for k, power in pairs(self.powers) do
        if power.remove then
            table.remove(self.powers, k)
        end
    end

    for k, snake in pairs(self.snakes) do
        if snake.remove then
            table.remove(self.snakes, k)
        end
    end

    for k, bat in pairs(self.bats) do
        if bat.remove then
            table.remove(self.bats, k)
        end
    end

    for k, lizard in pairs(self.lizards) do
        if lizard.remove then
            table.remove(self.lizards, k)
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function World3State:checkVictory()
    if self.round == 1 then
    
        if self.score >= 25000 + (250 * self.level * self.level) then
            return true
        else
            return false
        end
        
    else
        if self.score >= (self.round * 30000) + 25000 + (500 * self.level * self.level) then
            return true
        else
            return false
        end
    end
end

function World3State:render()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.world], 0, background_y - 480)

    for k, power in pairs(self.powers) do
        power:render()
    end

    for k, lava in pairs(self.lavas) do
        lava:render()
    end

    for k, snake in pairs(self.snakes) do
        snake:render()
    end

    for k, lizard in pairs(self.lizards) do
        lizard:render()
    end

    for k, bat in pairs(self.bats) do
        bat:render()
    end

    for _, projectile in pairs(self.projectiles) do
        projectile:render()
    end

    if self.health >= 2 then
        self.lives:render()
    end

    if self.health >= 2 then
        love.graphics.print('x', VIRTUAL_WIDTH -17, 25)
        love.graphics.print(tostring(self.health), VIRTUAL_WIDTH - 8, 25)
    end

    self.drone:render()
    renderScore(self.score)
    love.graphics.print('level:', 0, 5)
    love.graphics.print(tostring(self.level), 50, 5)
    love.graphics.print('world:', 0, 15)
    love.graphics.print(tostring(self.world), 50, 15)
end