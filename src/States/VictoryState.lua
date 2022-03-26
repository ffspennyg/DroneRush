VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    self.highScores = params.highScores
    self.score = params.score
 
    self.drone = params.drone
    self.projectiles = {}

    self.health = params.health
    self.lives = params.lives
    self.recovery = params.recovery

    self.level = params.level
    self.world = params.world
    self.round = params.round

    self.bossFight = params.bossFight

    self.win = false
end

function VictoryState:update(dt)
    if scrolling then
		background_y = (background_y + background_spd * dt) % BACKGROUND_LOOPING_POINT
    end

    self.drone:update(dt, self.projectiles)

    if self.level == 5 then
        self.bossFight = true
    end

    if self.world == 4 then
        self.win = true
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed ('return') then
        if self.bossFight == true then
            gStateMachine:change('boss-fight', {
                level = 1,
                world = self.world,
                score = self.score + 5000,
                highScores = self.highScores,
                drone = self.drone,
                lives = self.lives,
                health = self.health,
                recovery = self.recovery,
                bossFight = self.bossFight,
                round = self.round
            })
        elseif self.win == true then
            gStateMachine:change('win', {
                level = 1,
                world = self.world,
                score = self.score + 5000,
                highScores = self.highScores,
                drone = self.drone,
                lives = self.lives,
                health = self.health,
                recovery = self.recovery,
                bossFight = self.bossFight,
                round = self.round
            })
        else
            gStateMachine:change('count-down', {
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
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function VictoryState:render()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.world], 0, background_y - 480)
    
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

    love.graphics.setFont(gFonts['medium'])

    if self.level == 0 then
        love.graphics.printf("World " .. tostring(self.world) .. " complete!",
            0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf("Level " .. tostring(self.level) .. " complete!",
            0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
    end


    
    
        love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to start!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end