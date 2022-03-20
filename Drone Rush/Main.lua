require 'src/dependencies'

function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Drone Rush')

    love.graphics.setFont(gFonts['small'])

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT,WINDOW_HEIGHT, WINDOW_WIDTH, {
        fullscreen = false,
        vsync = true,
        resizeable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function loadHighScores()
    love.filesystem.setIdentity('dronerush.1st')


    local name = true
    local currentName = nil
    local counter = 1

    local scores = {}

    for i = 1, 10 do
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    for line in love.filesystem.lines('dronerush.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        name = not name
    end

    return scores
end

gStateMachine = StateMachine {
    ['start'] = function() return StartState() end,
    ['drone-select'] = function() return DroneSelectState() end,
    ['high-scores'] = function() return HighScoreState() end,
    ['enter-high-scores'] = function() return EnterHighScoreState() end,
    ['count-down'] = function() return CountdownState() end,
    ['play'] = function() return PlayState() end,
    ['game-over'] = function() return GameOverState() end,
    ['enter-high-score'] = function() return EnterHighScoreState() end,
    ['victory'] = function() return VictoryState() end,
    ['world-2'] = function() return World2State() end,
    ['boss-fight'] = function() return BossFightState() end,
    ['world-3'] = function() return World3State() end,
    ['win'] = function() return WinState() end
}

gStateMachine:change('start', {
    highScores = loadHighScores()
})

love.keyboard.keysPressed = {}

function love.update(dt)

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.draw()
    push:start()

    gStateMachine:render()

    push:finish()
end

function renderScore(score)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score:', VIRTUAL_WIDTH / 2, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 40, 5, 40, 'right')
end