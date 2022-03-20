PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.highScores = params.highScores
    self.score = params.score

    self.drone = params.drone
    self.rock = Rock()
    self.rocks = {}

    self.projectiles = {}
    self.bug = Bug()
    self.bugs = {}

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
    self.bossFight = params.bossFight
    self.round = params.round
end

function PlayState:update(dt)
    if scrolling then
		background_y = (background_y + background_spd * dt) % BACKGROUND_LOOPING_POINT
    end

    self.timer = self.timer + dt
    self.powerTimer = self.powerTimer + dt
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer > 1 then

        table.insert(self.rocks, Rock())
        table.insert(self.rocks, Rock())
        table.insert(self.rocks, Rock())

        self.spawnTimer = 0
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
            bossFight = self.bossFight,
            round = self.round
        })
    end

    self.drone:update(dt, self.projectiles)

    for p_key, projectile in pairs(self.projectiles) do
        projectile:update(dt)

        if projectile.y <= -PROJECTILE_LENGTH or projectile.y > VIRTUAL_HEIGHT then
            self.projectiles[p_key] = nil
        else
            for a_key, rock in pairs(self.rocks) do
                if projectile:collides(rock) then
                    rock:hit(self.bugs, self.powers)
                    self.score = self.score + 1 * rock.tier
                    self.projectiles[p_key] = nil
                end
            end

            for a_key, bug in pairs(self.bugs) do
                if projectile:collides(bug) then
                    bug:hit()
                    self.score = self.score + 3 * bug.tier
                    self.projectiles[p_key] = nil
                end
            end
        end
    end

    for k, bug in pairs(self.bugs) do
        bug:update(dt)

        if self.drone:collides(bug) then
            bug.remove = true
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

    for k, rock in pairs(self.rocks) do
        rock:update(dt)



        if not rock.scored then
            if self.drone.y + self.drone.height < rock.y then
                self.score = self.score + 7 * rock.tier
                rock.scored = true
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

        if self.drone:collides(rock) then
            rock.remove = true
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

        for k, rock in pairs(self.rocks) do
            if rock.remove then
                table.remove(self.rocks, k)
            end
        end

        for k, bug in pairs(self.bugs) do
            if bug.remove then
                table.remove(self.bugs, k)
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

function PlayState:checkVictory()
    if self.round == 1 then
    
        if self.score >= 250 + (250 * self.level * self.level) then
            return true
        else
            return false
        end
        
    else
        if self.score >= (self.round * 30000) + 500 + (500 * self.level * self.level) then
            return true
        else
            return false
        end
    end
end

function PlayState:render()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.world], 0, background_y - 480)

    for k, rock in pairs(self.rocks) do
        rock:render()
    end

    for k, bug in pairs(self.bugs) do
        bug:render()
    end

    for k, power in pairs(self.powers) do
        power:render()
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