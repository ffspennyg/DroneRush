GameOverState  = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.highScores = params.highScores
    self.score = params.score
    self.world = params.world
end

function GameOverState:update(dt)
    if scrolling then
		background_y = (background_y + background_spd * dt) % BACKGROUND_LOOPING_POINT
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local highScore = false

        local scoreIndex = 11

        for i = 10, 1, -1 do
            local score = self.highScores[i].score or 0
            if self.score > score then
                highScoreIndex = i
                highScore = true
            end
        end

        if highScore then
            gStateMachine:change('enter-high-score', {
                highScores = self.highScores,
                score = self.score,
                scoreIndex = highScoreIndex,
                world = self.world
            }) 
        else 
            gStateMachine:change('start', {
                highScores = self.highScores
            }) 
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.world], 0, background_y - 480)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter!', 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')
end