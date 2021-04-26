--[[
    Part of "S50's Intro to Game Development"
    Lecture 3
    
    -- BaseState Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
    
    Defines the base methods for all of the states, so they can be inherited
    by all states without having to define empty methods in each one.
]]

BaseState = Class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end