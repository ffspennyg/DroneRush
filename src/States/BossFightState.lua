BossFightState = Class{__includes = BaseState}

function BossFightState:enter(params)
    self.highScores = params.highScores
    self.score = params.score

    self.drone = params.drone
    self.projectiles = {}
    self.boss = Boss()

    self.bug = Bug()
    self.bugs ={}

    self.jelly = Jelly()
    self.jellys = {}

    self.bat = Bat()
    self.bats = {}

    self.health = params.health
    self.lives = params.lives
    self.recovery = params.recovery

    self.spawnTimer = 0
    self.timer = 0

    self.level = params.level
    self.world = params.world
    self.round = params.round

    self.bossFight = false
    
    self.bossDirection = 'right'
    self.bossMovementTimer = 0
end

function BossFightState:update(dt)
    if scrolling then
		background_y = (background_y + background_spd * dt) % BACKGROUND_LOOPING_POINT
    end

    self.boss:update(dt)
    self:movementBoss(dt)
    self.drone:update(dt, self.projectiles)

    for p_key, projectile in pairs(self.projectiles) do
        projectile:update(dt)

        if projectile.y <= -PROJECTILE_LENGTH or projectile.y > VIRTUAL_HEIGHT then
            self.projectiles[p_key] = nil
        else
            if projectile:collides(self.boss) then
                self.boss:hit()
                if self.world == 1 then
                    table.insert(self.bugs, Bug(self.boss.x, self.boss.y))
                    table.insert(self.bugs, Bug(self.boss.x, self.boss.y))
                elseif self.world == 2 then
                    table.insert(self.jellys, Jelly(self.boss.x, self.boss.y))
                    table.insert(self.jellys, Jelly(self.boss.x, self.boss.y))
                    table.insert(self.jellys, Jelly(self.boss.x, self.boss.y))
                elseif self.world == 3 then
                    table.insert(self.bats, Bat())
                    table.insert(self.bats, Bat())
                    table.insert(self.bats, Bat())
                end

                self.score = self.score + 50
                self.projectiles[p_key] = nil
            end

            for a_key, bug in pairs(self.bugs) do
                if projectile:collides(bug) then
                    bug:hit()
                    self.score = self.score + 30 * bug.tier
                    self.projectiles[p_key] = nil
                end
            end

            for a_key, jelly in pairs(self.jellys) do
                if projectile:collides(jelly) then
                    jelly:hit()
                    self.score = self.score + 30 * jelly.tier
                    self.projectiles[p_key] = nil
                end
            end

            for a_key, bat in pairs(self.bats) do
                if projectile:collides(bat) then
                    bat:hit()
                    self.score = self.score + 30 * bat.tier
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

    for k, bug in pairs(self.bugs) do
        if bug.remove then
            table.remove(self.bugs, k)
        end
    end

    for k, jelly in pairs(self.jellys) do
        jelly:update(dt)
        if self.drone:collides(jelly) then
            jelly.remove = true
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

    for k, jelly in pairs(self.jellys) do
        if jelly.remove then
            table.remove(self.jellys, k)
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

    for k, bat in pairs(self.bats) do
        if bat.remove then
            table.remove(self.bats, k)
        end
    end

    if self:checkVictory() then
        gStateMachine:change('victory', {
            level = 0,
            score = self.score,
            highScores = self.highScores,
            drone = self.drone,
            lives = self.lives,
            health = self.health,
            recovery = self.recovery,
            world = self.world + 1,
            bossFight = self.bossFight,
            round = self.round
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function BossFightState:checkVictory()
    if self.boss.remove == true then
        return true
    else
        return false
    end
end

function BossFightState:movementBoss(dt)
    self.bossMovementTimer = self.bossMovementTimer + dt

    if self.bossMovementTimer >= 0.5 then
        if self.bossDirection == 'right' then
            if self.boss.x >= VIRTUAL_WIDTH - BOSS_WIDTH - 5 then
                self.bossDirection = 'left'
                self.boss.y = self.boss.y + 5
            else
                self.boss.x = self.boss.x + 10
            end
        else
            if self.boss.x <= 5 then
                self.bossDirection = 'right'
                self.boss.y = self.boss.y + 5
            else
                self.boss.x = self.boss.x - 10
            end
        end

        self.bossMovementTimer = 0
    end
end

function BossFightState:render()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.world], 0, background_y - 480)

    for _, projectile in pairs(self.projectiles) do
        projectile:render()
    end

    for k, bug in pairs(self.bugs) do
        bug:render()
    end

    for k, jelly in pairs(self.jellys) do
        jelly:render()
    end

    for k, bat in pairs(self.bats) do
        bat:render()
    end

    if self.health >= 2 then
        self.lives:render()
    end

    if self.health >= 2 then
        love.graphics.print('x', VIRTUAL_WIDTH -17, 25)
        love.graphics.print(tostring(self.health), VIRTUAL_WIDTH - 8, 25)
    end

    if self.boss.remove == false then
        love.graphics.draw(gTextures['bosses'], gFrames['boss'][self.world],
        self.boss.x, self.boss.y)
    end

    self.drone:render()
    renderScore(self.score)
    love.graphics.print('level:', 0, 5)
    love.graphics.print(tostring(self.level), 50, 5)
    love.graphics.print('world:', 0, 15)
    love.graphics.print(tostring(self.world), 50, 15)
end