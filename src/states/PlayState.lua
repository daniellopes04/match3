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

function PlayState:init()
    
    -- Start our transition alpha at full, so we fade in
    self.transitionAlpha = 1

    -- Position in the grid which we're highlighting
    self.boardHighlightX = 0
    self.boardHighlightY = 0

    -- Timer used to switch the highlight rect's color
    self.rectHighlighted = false

    -- Flag to show whether we're able to process input (not swapping or clearing)
    self.canInput = true

    -- Tile we're currently highlighting (preparing to swap)
    self.highlightedTile = nil

    self.score = 0
    self.timer = 60

    -- Set our Timer class to turn cursor highlight on and off
    Timer.every(0.5, function()
        self.rectHighlighted = not self.rectHighlighted
    end)

    -- Subtract 1 from timer every second
    Timer.every(1, function()
        self.timer = self.timer - 1

        -- Play warning sound on timer if we get low
        if self.timer <= 5 then
            gSounds['clock']:play()
        end
    end)
end

function PlayState:enter(params)
    
    -- Grab level # from the params we're passed
    self.level = params.level

    -- Spawn a board and place it toward the right
    self.board = params.board or Board(VIRTUAL_WIDTH - 272, 16, self.level)

    -- Grab score from params if it was passed
    self.score = params.score or 0

    -- Score we have to reach to get to the next level
    self.scoreGoal = self.level * 1.25 * 1000
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- Go back to start if time runs out
    if self.timer <= 0 then
        
        -- Clear timers from prior PlayStates
        Timer.clear()
        
        gSounds['game-over']:play()

        gStateMachine:change('game-over', {
            score = self.score
        })
    end

    -- Go to next level if we surpass score goal
    if self.score >= self.scoreGoal then
        
        -- Clear timers from prior PlayStates
        -- Always clear before you change state, else next state's timers will also clear!
        Timer.clear()

        gSounds['next-level']:play()

        -- Change to begin game state with new level (incremented)
        gStateMachine:change('begin-game', {
            level = self.level + 1,
            score = self.score
        })
    end

    if self.canInput then
        -- Move cursor around based on bounds of grid, playing sounds
        if love.keyboard.wasPressed('up') then
            self.boardHighlightY = math.max(0, self.boardHighlightY - 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('down') then
            self.boardHighlightY = math.min(7, self.boardHighlightY + 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('left') then
            self.boardHighlightX = math.max(0, self.boardHighlightX - 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('right') then
            self.boardHighlightX = math.min(7, self.boardHighlightX + 1)
            gSounds['select']:play()
        end

        -- If we've pressed enter, to select or deselect a tile...
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            
            -- If same tile as currently highlighted, deselect
            local x = self.boardHighlightX + 1
            local y = self.boardHighlightY + 1
            
            -- If nothing is highlighted, highlight current tile
            if not self.highlightedTile then
                self.highlightedTile = self.board.tiles[y][x]

            -- If we select the position already highlighted, remove highlight
            elseif self.highlightedTile == self.board.tiles[y][x] then
                self.highlightedTile = nil

            -- If the difference between X and Y combined of this highlighted tile
            -- vs the previous is not equal to 1, also remove highlight
            elseif math.abs(self.highlightedTile.gridX - x) + math.abs(self.highlightedTile.gridY - y) > 1 then
                gSounds['error']:play()
                self.highlightedTile = nil
            else
                
                -- Swap grid positions of tiles
                local tempX = self.highlightedTile.gridX
                local tempY = self.highlightedTile.gridY

                local newTile = self.board.tiles[y][x]

                self.highlightedTile.gridX = newTile.gridX
                self.highlightedTile.gridY = newTile.gridY
                newTile.gridX = tempX
                newTile.gridY = tempY

                -- Swap tiles in the tiles table
                self.board.tiles[self.highlightedTile.gridY][self.highlightedTile.gridX] =
                    self.highlightedTile

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
            end
        end
    end

    Timer.update(dt)
    self.board:update(dt)
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
        gSounds['match']:stop()
        gSounds['match']:play()

        -- Add score and time for each match
        for k, match in pairs(matches) do
            self.score = self.score + #match * 50 + match[k].variety * 25
            self.timer = self.timer + #match
        end

        -- Remove any tiles that matched from the board, making empty spaces
        self.board:removeMatches()

        -- Gets a table with tween values for tiles that should now fall
        local tilesToFall = self.board:getFallingTiles()

        -- Tween new tiles that spawn from the ceiling over 0.25s to fill in
        -- the new upper gaps that exist
        Timer.tween(0.25, tilesToFall):finish(function()
            
            -- Recursively call function in case new matches have been created
            -- as a result of falling blocks once new blocks have finished falling
            self:calculateMatches()
        end)
    
    -- If no matches, we can continue playing
    else
        self.canInput = true
    end
end

function PlayState:render()
    -- Render board of tiles
    self.board:render()

    -- Render highlighted tile if it exists
    if self.highlightedTile then
        
        -- Multiply so drawing white rect makes it brighter
        love.graphics.setBlendMode('add')

        love.graphics.setColor(1, 1, 1, 96/255)
        love.graphics.rectangle('fill', (self.highlightedTile.gridX - 1) * 32 + (VIRTUAL_WIDTH - 272),
            (self.highlightedTile.gridY - 1) * 32 + 16, 32, 32, 4)

        -- Back to alpha
        love.graphics.setBlendMode('alpha')
    end

    -- Render highlight rect color based on timer
    if self.rectHighlighted then
        love.graphics.setColor(217/255, 87/255, 99/255, 1)
    else
        love.graphics.setColor(172/255, 50/255, 50/255, 1)
    end

    -- Draw actual cursor rect
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', self.boardHighlightX * 32 + (VIRTUAL_WIDTH - 272),
        self.boardHighlightY * 32 + 16, 32, 32, 4)

    -- GUI text
    love.graphics.setColor(56/255, 56/255, 56/255, 234/255)
    love.graphics.rectangle('fill', 16, 16, 186, 116, 4)

    love.graphics.setColor(99/255, 155/255, 1, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Level: ' .. tostring(self.level), 20, 24, 182, 'center')
    love.graphics.printf('Score: ' .. tostring(self.score), 20, 52, 182, 'center')
    love.graphics.printf('Goal : ' .. tostring(self.scoreGoal), 20, 80, 182, 'center')
    love.graphics.printf('Timer: ' .. tostring(self.timer), 20, 108, 182, 'center')
end