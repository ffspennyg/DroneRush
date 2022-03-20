WinState = Class{__includes = BaseState}

function WinState:enter(params)
    self.highScores = params.highScores
    self.score = params.score
 
    self.drone = params.drone
    self.projectiles = {}

    self.health = params.health
    self.lives = params.lives
    self.recovery = params.recovery

    self.level = 0
    self.world = 1
    self.round = params.round

    self.bossFight = params.bossFight

    self.win = params.win
end

function WinState:update(dt)
    if scrolling then
		background_y = (background_y + background_spd * dt) % BACKGROUND_LOOPING_POINT
    end

    self.drone:update(dt, self.projectiles)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

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
            round = self.round + 1
        })

    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function WinState:render()
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
        
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('CONGRATULATIONS!', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to Continue!', 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
end