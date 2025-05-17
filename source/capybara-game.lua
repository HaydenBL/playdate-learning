import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd = playdate
local gfx = pd.graphics

-- Player
local playerStartX = 40
local playerStartY = 120
local playerSpeed = 3
local collisionOffset = 4
local playerImage = gfx.image.new("images/capybara")
local playerSprite = gfx.sprite.new(playerImage)
playerSprite:setCollideRect(collisionOffset, collisionOffset, playerSprite.width - (collisionOffset*2), playerSprite.height - (collisionOffset*2))
playerSprite:moveTo(playerStartX, playerStartY)
playerSprite:add()

-- Obstacle
local obstacleStartSpeed = 5
local obstacleSpeed = obstacleStartSpeed
local obstacleImage = gfx.image.new("images/rock")
local obstacleSprite = gfx.sprite.new(obstacleImage)
obstacleSprite.collisionResponse = gfx.sprite.kCollisionTypeOverlap
obstacleSprite:setCollideRect(collisionOffset, collisionOffset, obstacleSprite.width - (collisionOffset*2), obstacleSprite.height - (collisionOffset*2))
obstacleSprite:moveTo(450, 240)
obstacleSprite:add()

-- Sound
local boomPlayer = pd.sound.sampleplayer.new("sounds/boom")
local assPlayer = pd.sound.sampleplayer.new("sounds/ass")
boomPlayer:setFinishCallback(function ()
    assPlayer:play()
end)

-- Game state
local State = {
    STOPPED = 0,
    ACTIVE = 1
}
local gameState = State.STOPPED
local score = 0


function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()

    if gameState == State.STOPPED then
        gfx.drawTextAligned("Press A to start", 200, 40, kTextAlignment.center)
        if pd.buttonJustPressed(pd.kButtonA) then
            gameState = State.ACTIVE
            ResetGameState()
        end
    elseif gameState == State.ACTIVE then
        UpdatePlayer()
        UpdateObstacle()
    end
    DrawScore()
end

function ResetGameState()
    playerSprite:moveTo(playerStartX, playerStartY)
    obstacleSprite:moveTo(450, math.random(40, 200))
    score = 0
    obstacleSpeed = obstacleStartSpeed
end

function UpdatePlayer()
    local crankPosition = pd.getCrankPosition()
    if crankPosition <= 90 or crankPosition >= 270 then
        playerSprite:moveBy(0, -playerSpeed)
    else
        playerSprite:moveBy(0, playerSpeed)
    end

    if playerSprite.y > 270 or playerSprite.y < -30 then
        gameState = State.STOPPED
    end
end

function UpdateObstacle()
    local actualX, actualY, collisions, collisionLength = obstacleSprite:moveWithCollisions(obstacleSprite.x - obstacleSpeed, obstacleSprite.y)
    if obstacleSprite.x < -20 then
        obstacleSprite:moveTo(450, math.random(40, 200))
        PointScored()
    end
    if collisionLength > 0 then
        ScreenShake(500, 5)
        boomPlayer:play()
        gameState = State.STOPPED
    end
end

function PointScored()
    score += 1
    obstacleSpeed += 0.2
end

function DrawScore()
    gfx.drawTextAligned("Score: " .. score, 390, 10, kTextAlignment.right)
end

-- (Below function yoinked from docs)
-- This function relies on the use of timers, so the timer core library
-- must be imported, and updateTimers() must be called in the update loop
function ScreenShake(shakeTime, shakeMagnitude)
    -- Creating a value timer that goes from shakeMagnitude to 0, over
    -- the course of 'shakeTime' milliseconds
    local shakeTimer = playdate.timer.new(shakeTime, shakeMagnitude, 0)
    -- Every frame when the timer is active, we shake the screen
    shakeTimer.updateCallback = function(timer)
        -- Using the timer value, so the shaking magnitude
        -- gradually decreases over time
        local magnitude = math.floor(timer.value)
        local shakeX = math.random(-magnitude, magnitude)
        local shakeY = math.random(-magnitude, magnitude)
        playdate.display.setOffset(shakeX, shakeY)
    end
    -- Resetting the display offset at the end of the screen shake
    shakeTimer.timerEndedCallback = function()
        playdate.display.setOffset(0, 0)
    end
end
