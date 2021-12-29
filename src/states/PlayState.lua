--[[
    Part of "S50's Intro to Game Development"
    Lecture 3
    
    -- PlayState Class --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
    
    Represents the main portion of the game in which we are actively playing.
    The player moves a cursor through a grid and selects two tiles to swap. If the swap
    results in three or more tiles lined up verticaly or horizontaly, destroy the tiles
    and add their points to the player's score. Once the player gets enough points,
    proceed to next level. There is also a timer and if the player doesn't move to 
    the next level before the timer runs out, it gets redirected to the main menu or 
    top score menu, if it gets a high score.
]]

PlayState = Class{__includes = BaseState}

function PlayState:enter()
    self.offsetX = 128
    self.offsetY = 16
    self.board = Board(self.offsetX, self.offsetY)

    -- Flag to show whether we're able to process input (not swapping or clearing)
    self.canInput = true
    
    -- tile we're currently highlighting (preparing to swap)
    self.highlightedTile = nil
    self.highlightedX, self.highlightedY = 0, 0

    self.score = 0

    -- Current selected tile, changed with arrow keys
    self.selectedTile = self.board.tiles[1][1]
end

function PlayState:update(dt)
    local x, y = self.selectedTile.gridX, self.selectedTile.gridY

    if self.canInput then
        -- Moving the selected tile
        if love.keyboard.wasPressed('up') then
            if y > 1 then
                self.selectedTile = self.board.tiles[y - 1][x]
            end
        elseif love.keyboard.wasPressed('down') then
            if y < 8 then
                self.selectedTile = self.board.tiles[y + 1][x]
            end
        elseif love.keyboard.wasPressed('left') then
            if x > 1 then
                self.selectedTile = self.board.tiles[y][x - 1]
            end
        elseif love.keyboard.wasPressed('right') then
            if x < 8 then
                self.selectedTile = self.board.tiles[y][x + 1]
            end
        end
        
        -- When enter is pressed we highlight a tile
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            if not self.highlightedTile then
                self.highlightedTile = true
                self.highlightedX, self.highlightedY = self.selectedTile.gridX, self.selectedTile.gridY
                self.highlightedTile = self.board.tiles[y][x]
            -- if we select the position already highlighted, remove highlight
            elseif self.highlightedTile == self.board.tiles[y][x] then
                self.highlightedTile = nil
            elseif math.abs(self.highlightedX - self.selectedTile.gridX) + math.abs(self.highlightedY - self.selectedTile.gridY) > 1 then
                self.highlightedTile = nil
            else
                -- Swap grid positions of tiles
                local tempX, tempY = self.highlightedTile.gridX, self.highlightedTile.gridY
                local newTile = self.board.tiles[y][x]

                self.highlightedTile.gridX = newTile.gridX
                self.highlightedTile.gridY = newTile.gridY
                newTile.gridX = tempX
                newTile.gridY = tempY

                -- Swap tiles in the tiles table
                self.board.tiles[self.highlightedTile.gridY][self.highlightedTile.gridX] = self.highlightedTile
                self.board.tiles[newTile.gridY][newTile.gridX] = newTile

                -- Tween coordinates between the two so they swap
                Timer.tween(0.1, {
                    [self.highlightedTile] = {x = newTile.x, y = newTile.y},
                    [newTile] = {x = self.highlightedTile.x, y = self.highlightedTile.y}
                })
                -- Once the swap is finished, we can tween falling blocks as needed
                :finish(function()
                    self:calculateMatches()
                end)

                self.selectedTile = self.highlightedTile
                self.highlightedTile = nil
            end
        end
    end

    if love.keyboard.wasPressed('escape') then 
        love.event.quit()
    end

    Timer.update(dt)
end

--[[
    Calculates whether any matches were found on the board and tweens the needed
    tiles to their new destinations if so. Also removes tiles from the board that
    have matched and replaces them with new randomized tiles, deferring most of this
    to the Board class.
]]
function PlayState:calculateMatches()
    self.highlightedTile = nil

    -- If we have any matches, remove them and tween the falling blocks that result
    local matches = self.board:calculateMatches()

    if matches then
        -- gSounds['match']:stop()
        -- gSounds['match']:play()

        -- Add score for each match
        for k, match in pairs(matches) do
            self.score = self.score + #match * 50
        end

        -- Remove any tiles that matched from the board
        self.board:removeMatches()

        -- Gets a table with tween values for tiles that should now fall
        local tilesToFall = self.board:getFallingTiles()

        -- First, tween the falling tiles over 0.25s
        Timer.tween(0.25, tilesToFall):finish(function()
            local newTiles = self.board:getNewTiles()
            
            -- Then, tween new tiles that spawn from the ceiling over 0.25s to fill in
            -- the new upper gaps that exist
            Timer.tween(0.25, newTiles):finish(function()
                -- Recursively call function in case new matches have been created
                -- as a result of falling blocks once new blocks have finished falling
                self:calculateMatches()
            end)
        end)
    -- If no matches, we can continue playing
    else
        self.canInput = true
    end
end

function PlayState:render()
    -- Draws the board with and offset so it's centered
    self.board:render()

    -- Highlights selected tile
    if self.highlightedTile then
        -- Multiply so drawing white rect makes it brighter
        love.graphics.setBlendMode('add')

        love.graphics.setColor(1, 1, 1, 96/255)
        love.graphics.rectangle('fill', (self.highlightedTile.gridX - 1) * 32 + self.offsetX,
            (self.highlightedTile.gridY - 1) * 32 + self.offsetY, 32, 32, 4)

        -- Back to alpha
        love.graphics.setBlendMode('alpha')
    end

    -- Draws rectangle around current tile
    love.graphics.setColor(1, 0, 0, 234/255)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', self.selectedTile.x + self.offsetX, self.selectedTile.y + self.offsetY, 32, 32, 4)
    love.graphics.setColor(1, 1, 1, 1)
end