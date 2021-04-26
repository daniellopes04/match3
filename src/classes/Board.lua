--[[
    Part of "S50's Intro to Game Development"
    Lecture 3
    
    -- Board Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04

    Defines the board of tiles where we must look for three or more matching tiles 
    horizontally or vertically. 
]]

Board = Class{}

function Board:init(x, y)
    self.x = x
    self.y = Y

    -- To keep track of the matches
    self.matches = {}

    self:initializeTiles()
end

--[[
    Populates a table with mini-tables each containing X and Y coordinates for tiles
    Each tile also have a quad ID associated with it
]] 
function Board:initializeTiles()
    -- The tiles which compose the board
    self.tiles = {}

    -- Iterate over columns of tiles
    for y = 1, 8 do 
        -- Insert empty row
        table.insert(self.tiles, {})

        -- Iterate over rows of tiles
        for x = 1, 8 do 
            -- For the blank row inserted, add the tiles
            table.insert(self.tiles[y], Tile(
                x, y,
                math.random(18),
                math.random(6)
            ))
        end
    end
end

function Board:render()
    -- Draws all the tiles on the screen
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end
