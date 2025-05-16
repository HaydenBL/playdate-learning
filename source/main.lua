import "CoreLibs/graphics"
import "CoreLibs/sprites"

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

-- Game state
local State = {
    STOPPED = 0,
    ACTIVE = 1
}
local gameState = State.STOPPED

function pd.update()
    gfx.sprite.update()

    if gameState == State.STOPPED then
        gfx.drawTextAligned("Press A to start", 200, 40, kTextAlignment.center)
        if pd.buttonJustPressed(pd.kButtonA) then
            gameState = State.ACTIVE
            ResetGameState()
        end
    elseif gameState == State.ACTIVE then
        UpdatePlayer()
    end    
end

function ResetGameState()
    playerSprite:moveTo(playerStartX, playerStartY)
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
