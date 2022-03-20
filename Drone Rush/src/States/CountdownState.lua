CountdownState = Class{__includes = BaseState}

COUNTDOWN_TIME = 0.75

function CountdownState:enter(params)
    self.drone = params.drone
	self.highScores = params.highScores
	self.projectiles = {}

	self.health = params.health
	self.lives = params.lives
	self.recovery = params.recovery

	self.score = params.score
	self.level = params.level
	self.world = params.world
	self.bossFight = params.bossFight

	self.count = 3
	self.timer = 0
	self.round = params.round
end

function CountdownState:update(dt)
	if scrolling then
		background_y = (background_y + background_spd * dt) % BACKGROUND_LOOPING_POINT
    end
	
    self.drone:update(dt, self.projectiles)
    for p_key, projectile in pairs(self.projectiles) do
        projectile:update(dt)

        if projectile.y <= -PROJECTILE_LENGTH or projectile.y > VIRTUAL_HEIGHT then
            self.projectiles[p_key] = nil
        end
    end

	self.timer = self.timer + dt

	if self.timer > COUNTDOWN_TIME then
		self.timer = self.timer % COUNTDOWN_TIME
		self.count = self.count - 1

		if self.count == 0 then
			if self.world == 1 then
				gStateMachine:change('play', {
					drone = self.drone,
					highScores = self.highScores,
					score = self.score,
					health = self.health,
					lives = self.lives,
					level = self.level + 1,
					recovery = self.recovery,
					world = self.world,
					bossFight = self.bossFight,
					round = self.round
				})
				
			elseif self.world == 2 then
				gStateMachine:change('world-2', {
					drone = self.drone,
					highScores = self.highScores,
					score = self.score,
					health = self.health,
					lives = self.lives,
					level = self.level + 1,
					recovery = self.recovery,
					world = self.world,
					bossFight = self.bossFight,
					round = self.round
				})
				
			elseif self.world == 3 then
				gStateMachine:change('boss-fight', {
					drone = self.drone,
					highScores = self.highScores,
					score = self.score,
					health = self.health,
					lives = self.lives,
					level = self.level + 1,
					recovery = self.recovery,
					world = self.world,
					bossFight = self.bossFight,
					round = self.round
				})
			end
		end
	end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function CountdownState:render()
	love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.world], 0, background_y - 480)
	self.lives:render()
	self.drone:render()
	love.graphics.setFont(gFonts['huge'])
	love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end