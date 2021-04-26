--[[
    Part of "S50's Intro to Game Development"
    Lecture 3
    
    -- Constants file --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04

    All the constants and global values used throughout the game are initialized here.
]]

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

gTextures = {
    ['main'] = love.graphics.newImage('graphics/match3.png')
}

gFrames = {
    ['tiles'] = GenerateQuadsTiles(gTextures['main'])
}
