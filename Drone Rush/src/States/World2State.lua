World2State = Class {__includes = BaseState}

function World2State:enter(params)
    self.highScores = params.highScores
    self.score = params.score

    self.drone = params.drone
    self.projectiles = {}

    self.buoy = Buoy()
    self.buoys = {}
    
    self.crab = Crab()
    self.crabs = {}
    
    self.turtle = Turtle()
    self.turtles = {}

    self.octopus = Octopus()
    self.octopuss = {}

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

function World2State:update(dt)
    if scrolling then
		background_y = (background_y + background_spd * dt) % BACKGROUND_LOOPING_POINT
    end

    self.drone:update(dt, self.projectiles)

    self.timer = self.timer + dt
    self.powerTimer = self.powerTimer + dt
    self.spawnTimer = self.spawnTimer + dt

    if self.spawnTimer > 1 then

        table.insert(self.buoys, Buoy())
        table.insert(self.buoys, Buoy())

        self.spawnTimer = 0

        if math.random(2) == 1 then
            table.insert(self.turtles, Turtle())

            self.spawnTimer = 0
        else
            table.insert(self.octopuss, Octopus())

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
            for a_key, buoy in pairs(self.buoys) do
                if projectile:collides(buoy) then
                    buoy:hit(self.crabs)
                    self.score = self.score + 1 * buoy.tier
                    self.projectiles[p_key] = nil
                end
            end

            for a_key, crab in pairs(self.crabs) do
                if projectile:collides(crab) then
                    crab:hit()
                    self.score = self.score + 3 * crab.tier
                    self.projectiles[p_key] = nil
                end
            end

            for a_key, turtle in pairs(self.turtles) do
                if projectile:collides(turtle) then
                    turtle:hit(self.powers)
                    self.score = self.score + 1 * turtle.tier
                    self.projectiles[p_key] = nil
                end
            end

            for a_key, octopus in pairs(self.octopuss) do
                if projectile:collides(octopus) then
                    octopus:hit(self.powers)
                    self.score = self.score + 1 * octopus.tier
                    self.projectiles[p_key] = nil
                end
            end
        end
    end

    for k, crab in pairs(self.crabs) do
        crab:update(dt)
        if self.drone:collides(crab) then
            crab.remove = true
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

    for k, octopus in pairs(self.octopuss) do
        octopus:update(dt)
        if self.drone:collides(octopus) then
            octopus.remove = true
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

    for k, turtle in pairs(self.turtles) do
        turtle:update(dt)
        if self.drone:collides(turtle) then
            turtle.remove = true
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

    for k, buoy in pairs(self.buoys) do
        buoy:update(dt)
        if not buoy.scored then
            if self.drone.y + self.drone.height < buoy.y then
                self.score = self.score + 7 * buoy.tier
                buoy.scored = true
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

        if self.drone:collides(buoy) then
            buoy.remove = true
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

        for k, buoy in pairs(self.buoys) do
            if buoy.remove then
                table.remove(self.buoys, k)
            end
        end

        for k, turtle in pairs(self.turtles) do
            if turtle.remove then
                table.remove(self.turtles, k)
            end
        end

        for k, octopus in pairs(self.octopuss) do
            if octopus.remove then
                table.remove(self.octopuss, k)
            end
        end

        for k, crab in pairs(self.crabs) do
            if crab.remove then
                table.remove(self.crabs, k)
            end
        end

        for k, power in pairs(self.powers) do
            if power.remove then
                table.remove(self.powers, k)
            end
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function World2State:checkVictory()
    if self.round == 1 then
    
        if self.score >= 250 + (250 * self.level * self.level) then
            return true
        else
            return false
        end
        
    else
        if self.score >= (self.round * 30000) + 10500 + (500 * self.level * self.level) then
            return true
        else
            return false
        end
    end
end

function World2State:render()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.world], 0, background_y - 480)

    for k, buoy in pairs(self.buoys) do
        buoy:render()
    end

    for k, crab in pairs(self.crabs) do
        crab:render()
    end

    for k, turtle in pairs(self.turtles) do
        turtle:render()
    end

    for k, power in pairs(self.powers) do
        power:render()
    end

    for k, octopus in pairs(self.octopuss) do
        octopus:render()
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