StartState = Class{__includes = BaseState}

local highlighted = 1

function StartState:enter(params)
    self.highScores = params.highScores
    self.image = love.graphics.newImage('graphics/drone.png')
    self.health = 2
    self.lives = Lives()
    self.world = 3
end

function StartState:update(dt)

    if scrolling then
		background_y = (background_y + background_spd * dt) % BACKGROUND_LOOPING_POINT
    end

    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

        if highlighted == 1 then
            gStateMachine:change('drone-select', {
                highScores = self.highScores,
                health = self.health,
                lives = self.lives,
                world = self.world
            })
        else
            gStateMachine:change('high-scores', {
                highScores = self.highScores,
                world = self.world
            })
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

end

function StartState:render()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.world], 0, background_y - 480)

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf("Drone Rush!", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

    if highlighted == 1 then
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 70,
        VIRTUAL_WIDTH, 'center')

        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 90,
        VIRTUAL_WIDTH, 'center')
    end

    if highlighted == 2 then
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 90,
        VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 70,
        VIRTUAL_WIDTH, 'center')
    end

    love.graphics.draw(self.image, VIRTUAL_WIDTH / 2 - 48, VIRTUAL_HEIGHT / 2)

    self.lives:render()
end