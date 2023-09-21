--[[
    Part of "S50's Intro to Game Development"
    Lecture 3
    
    -- Dependencies file --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04

    All the dependencies, including libraries, classes and global variables are 
    loaded here.
]]

-- Push library
-- https://github.com/Ulydev/push
push = require 'lib/push'

-- Class library
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'

-- Knife library
-- https://github.com/airstruck/knife/
Timer = require 'lib/knife.timer'

-- Constants, global variables and utilities functions
require 'src/constants'
require 'src/Util'

-- Game classes
require 'src/Board'
require 'src/Tile'

-- State machine and the game states
require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/BeginGameState'
require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/GameOverState'

gSounds = {
    ['music'] = love.audio.newSource('sounds/music3.mp3', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['error'] = love.audio.newSource('sounds/error.wav', 'static'),
    ['match'] = love.audio.newSource('sounds/match.wav', 'static'),
    ['clock'] = love.audio.newSource('sounds/clock.wav', 'static'),
    ['game-over'] = love.audio.newSource('sounds/game-over.wav', 'static'),
    ['next-level'] = love.audio.newSource('sounds/next-level.wav', 'static')
}

gTextures = {
    ['main'] = love.graphics.newImage('graphics/match3.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ["particle"] = love.graphics.newImage("graphics/particle.png")
}

gFrames = {
    --['tiles'] = GenerateQuadsTilesOld(gTextures['main'])
    ['tiles'] = GenerateQuadsTiles(gTextures['main'])
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}
