--[[
    Part of "S50's Intro to Game Development"
    Lecture 3

    -- BeginGameState Class --

    Made by: Daniel de Sousa
    https://github.com/daniellopes04

    Represents the state the game is in right before we start playing;
    should fade in, display a drop-down "Level X" message, then transition
    to the PlayState, where we can finally use player input.
]]

BeginGameState = Class{__includes = BaseState}

function BeginGameState:init()
    
    -- Start our transition alpha at full, so we fade in
    self.transitionAlpha = 1

    -- Start our level # label off-screen
    self.levelLabelY = -64

    self.timer = 60
    self.score = 0
end

function BeginGameState:enter(def)
    
    -- Grab level # from the def we're passed
    self.level = def.level

    -- Set timer and score to params value
    self.timer = def.timer
    self.score = def.score

    -- Spawn a board and place it toward the right
    self.board = Board(VIRTUAL_WIDTH - 272, 16, self.level)

    -- Animate our white screen fade-in, then animate a drop-down with the level text
    -- First, over a period of 1 second, transition our alpha to 0
    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    })
    
    -- Once that's finished, start a transition of our text label to
    -- the center of the screen over 0.25 seconds
    :finish(function()
        Timer.tween(0.25, {
            [self] = {levelLabelY = VIRTUAL_HEIGHT / 2 - 8}
        })
        
        -- After that, pause for one second with Timer.after
        :finish(function()
            Timer.after(1, function()
                
                -- Then, animate the label going down past the bottom edge
                Timer.tween(0.25, {
                    [self] = {levelLabelY = VIRTUAL_HEIGHT + 30}
                })
                
                -- Once that's complete, we're ready to play!
                :finish(function()
                    gStateMachine:change('play', {
                        level = self.level,
                        board = self.board,
                        timer = self.timer,
                        score = self.score
                    })
                end)
            end)
        end)
    end)
end

function BeginGameState:update(dt)
    Timer.update(dt)
end

function BeginGameState:render()
    
    -- Render board of tiles
    self.board:render()

    -- Render Level # label and background rect
    love.graphics.setColor(95/255, 205/255, 228/255, 200/255)
    love.graphics.rectangle('fill', 0, self.levelLabelY - 8, VIRTUAL_WIDTH, 48)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level),
        0, self.levelLabelY, VIRTUAL_WIDTH, 'center')

    -- Our transition foreground rectangle
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end