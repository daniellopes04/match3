--[[
    Part of "S50's Intro to Game Development"
    Lecture 3
    
    -- Dependencies file --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04

    All the dependencies, including libraries and classes are loaded here.
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

-- State machine and the game states
