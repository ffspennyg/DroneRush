push = require 'lib/push'
Class = require 'lib/class'

require 'lib/constants'
require 'src/StateMachine'
require 'src/Util'

require 'src/States/BaseState'
require 'src/States/StartState'
require 'src/States/DroneSelectState'
require 'src/States/HighScoreState'
require 'src/States/EnterHighScoreState'
require 'src/States/CountdownState'
require 'src/States/PlayState'
require 'src/States/GameOverState'
require 'src/States/VictoryState'
require 'src/States/World2State'
require 'src/States/BossFightState'
require 'src/States/World3State'
require 'src/States/WinState'

require 'src/Class/Lives'

require 'src/Class/Drone'
require 'src/Class/Projectile'

require 'src/Class/Power'

require 'src/Class/Rock'
require 'src/Class/Bug'

require 'src/Class/Buoy'
require 'src/Class/Crab'
require 'src/Class/Turtle'
require 'src/Class/Octopus'
require 'src/Class/Jelly'

require 'src/Class/Lava'
require 'src/Class/Snake'
require 'src/Class/Bat'
require 'src/Class/Lizard'

require 'src/Class/Boss'

gFonts = {
    ['small'] = love.graphics.newFont('fonts/Gameboy.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/Gameboy.ttf', 12),
    ['large'] = love.graphics.newFont('fonts/Gameboy.ttf', 24),
    ['huge'] = love.graphics.newFont('fonts/Gameboy.ttf', 32)
}

gTextures = {
    ['main'] = love.graphics.newImage('graphics/dronerush.png'),
    ['health'] = love.graphics.newImage('graphics/droneHealth.png'),
    ['drones'] = love.graphics.newImage('graphics/drone.png'),
    ['bugs'] = love.graphics.newImage('graphics/bugs.png'),
    ['backgrounds'] = love.graphics.newImage('graphics/backgrounds.png'),
    ['world2'] = love.graphics.newImage('graphics/world2.png'),
    ['bosses'] = love.graphics.newImage('graphics/bosses.png'),
    ['powers'] = love.graphics.newImage('graphics/power.png'),
    ['world3'] = love.graphics.newImage('graphics/world3.png')
}

gFrames = {
    ['drones'] = GenerateQuadsDrones(gTextures['drones']),
    ['rock'] = GenerateQuadsRocks(gTextures['main']),
    ['health'] = GenerateQuadsDroneHealth(gTextures['health']),
    ['bug'] = GenerateQuadsBugs(gTextures['bugs']),
    ['jelly'] = GenerateQuadsJelly(gTextures['bugs']),
    ['backgrounds'] = GenerateQuadsBackgrounds(gTextures['backgrounds']),
    ['crabs'] = GenerateQuadsCrabs(gTextures['world2']),
    ['buoys'] = GenerateQuadsBuoys(gTextures['world2']),
    ['boss'] = GenerateQuadsBoss(gTextures['bosses']),
    ['turtle'] = GenerateQuadsTurtles(gTextures['world2']),
    ['octopus'] = GenerateQuadsOctopus(gTextures['world2']),
    ['power'] = GenerateQuadsPower(gTextures['powers']),
    ['lava'] = GenerateQuadsLava(gTextures['world3']),
    ['snake'] = GenerateQuadsSnake(gTextures['world3']),
    ['bat'] = GenerateQuadsBat(gTextures['bugs']),
    ['lizard'] = GenerateQuadsLizard(gTextures['world3'])
}