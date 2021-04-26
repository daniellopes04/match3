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
require 'src/classes/Board'
require 'src/classes/Tile'

-- State machine and the game states
require 'src/StateMachine'
require 'src/states/StartState'
require 'src/states/PlayState'

gTextures = {
    ['main'] = love.graphics.newImage('graphics/match3.png')
}

gFrames = {
    ['tiles'] = GenerateQuadsTiles(gTextures['main'])
}
