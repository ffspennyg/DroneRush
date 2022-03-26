DroneSelectState = Class{__includes = BaseState}

function DroneSelectState:enter(params)
    self.highScores = params.highScores
    self.health = params.health
    self.lives = params.lives
    self.world = params.world
    self.bossFight = false
    self.round = 1
end

function DroneSelectState:init()
    self.currentDrone = 1
end

function DroneSelectState:update(dt)
    if scrolling then
		background_y = (background_y + background_spd * dt) % BACKGROUND_LOOPING_POINT
    end

    if love.keyboard.wasPressed('left') then
        self.currentDrone = self.currentDrone - 1
        if self.currentDrone < 1 then
            self.currentDrone = 12
        end
    elseif love.keyboard.wasPressed('right') then
        self.currentDrone = self.currentDrone + 1
        if self.currentDrone > 12 then
            self.currentDrone = 1
        end
    end

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then

        gStateMachine:change('count-down', {
            drone = Drone(self.currentDrone),
            highScores = self.highScores,
            health = self.health,
            lives = self.lives,
            score = 0,
            level = 0,
            recovery = 500,
            world = self.world,
            bossFight = self.bossFight,
            round = self.round
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function DroneSelectState:render()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.world], 0, background_y - 480)

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Select your Drone!", 0, VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Enter to continue!", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')
    love.graphics.draw(gTextures['drones'], gFrames['drones'][1 + (self.currentDrone - 1)],
        VIRTUAL_WIDTH / 2 - 8, VIRTUAL_HEIGHT - 30)

    self.lives:render()
end