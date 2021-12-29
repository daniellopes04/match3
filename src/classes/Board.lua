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
    self.y = y

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
    for tileY = 1, 8 do 
        -- Insert empty row
        table.insert(self.tiles, {})

        -- Iterate over rows of tiles
        for tileX = 1, 8 do 
            -- For the blank row inserted, add the tiles
            table.insert(self.tiles[tileY], Tile(
                tileX, tileY,
                math.random(18),
                math.random(1)
            ))
        end
    end
end

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}

    -- How many of the same color blocks in a row we've found
    local matchNum = 1

    -- Horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        
        -- Every horizontal tile
        for x = 2, 8 do
            -- If this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                -- Set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color

                -- If we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- Go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do
                        -- Add each tile to the match that's in that match
                        table.insert(match, self.tiles[y][x2])
                    end

                    -- Add this match to our total matches table
                    table.insert(matches, match)
                end

                -- Don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end

                matchNum = 1
            end
        end

        -- Account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- Go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    -- Vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- Every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                -- Don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- Account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- Go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum, -1 do
                table.insert(match, self.tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    -- Store matches for later reference
    self.matches = matches

    return #self.matches > 0 and self.matches or false
end

--[[
    Remove the matches from the Board by just setting the Tile slots within them to nil,
    then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- Tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- For each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            -- If our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                -- If the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    -- Put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- Set its prior position to nil
                    self.tiles[y][x] = nil

                    -- Tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- Set space back to 0, set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- Create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- If the tile is nil, we need to add a new one
            if not tile then
                local tile = Tile(x, y, math.random(18), math.random(1))
                tile.y = -32
                self.tiles[y][x] = tile

                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end

function Board:getNewTiles()
    return {}
end

function Board:render()
    -- Draws all the tiles on the screen
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end
