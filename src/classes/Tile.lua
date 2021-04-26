--[[
    Part of "S50's Intro to Game Development"
    Lecture 3
    
    -- Tile Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varieties adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety)
    -- Position of tile in board
    self.gridX = x
    self.gridY = y

    -- Coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- Tile color and variety/points
    self.color = color
    self.variety = variety
end

function Tile:render(x, y)
    -- Draw a tile shadow
    love.graphics.setColor(0.1, 0.1, 0.2, 1)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- Draw tiles
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
end