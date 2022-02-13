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

    self.shiny = true and math.random() > 0.95 or false 

    -- Defines the brick's particle system, emitted on hit
    self.psystem = love.graphics.newParticleSystem(gTextures["particle"], 10)

    -- Particle system behavior functions
    self.psystem:setParticleLifetime(0.5, 1)              -- lasts between 0.5 and 1 second
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)      -- gives acceleration 
    self.psystem:setEmissionRate(5)
    self.psystem:setEmissionArea("normal", 8, 8, 1, true) -- spread of particles

    -- Over the particle's lifetime, we transition from first to second color
    self.psystem:setColors(
        -- First color
        251/255, 242/255, 54/255, 1,
        -- Second color
        1, 1, 1, 0
    )
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
    
    if self.shiny then
        love.graphics.draw(self.psystem, self.x + (VIRTUAL_WIDTH - 272) + 16, self.y + 32)
    end
end

function Tile:update(dt)
    if self.shiny then
        self.psystem:update(dt)
    end
end

-- Separate function for the particle system
function Tile:renderParticles()
    if self.shiny then
        love.graphics.draw(self.psystem, self.x + (VIRTUAL_WIDTH - 272) + 16, self.y + 32)
    end
end