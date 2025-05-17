import "CoreLibs/graphics"

local pd = playdate
local gfx = pd.graphics

local screenWidth, screenHeight = playdate.display.getSize()

local clickPlayer = pd.sound.sampleplayer.new("sounds/selection")

local fontPathsNontendo = {
    [playdate.graphics.font.kVariantNormal] = "fonts/Nontendo/Nontendo-Light",
    [playdate.graphics.font.kVariantBold] = "fonts/Nontendo/Nontendo-Bold"
}
local fontNontendo = gfx.font.newFamily(fontPathsNontendo)

local activeIndex = 1;
local texts = {
    "Knack 1",
    "Knack 2",
    "Knack 3",
    "Knack 4",
    "Knack 5"
}
local numberOfTexts = table.getsize(texts)

local degreesBetweenTexts = 360 / numberOfTexts

math.round = function(n) return n >= 0.0 and n-n%-1 or n-n% 1 end

-- drawTextScaled yoinked from https://devforum.play.date/t/add-a-drawtextscaled-api-see-code-example/7108
-- idk if this was added to the API since?
function playdate.graphics.drawTextScaled(text, x, y, scale, font)
    local padding = string.upper(text) == text and 6 or 0 -- Weird padding hack?
    local w <const> = font:getTextWidth(text)
    local h <const> = font:getHeight() - padding
    local img <const> = gfx.image.new(w, h, gfx.kColorClear)
    gfx.lockFocus(img)
    gfx.setFont(font)
    gfx.drawTextAligned(text, w / 2, 0, kTextAlignment.center)
    gfx.unlockFocus()
    img:drawScaled(x - (scale * w) / 2, y - (scale * h) / 2, scale)
end

local function constrain(n, low, high)
  return math.max(math.min(n, high), low);
end

local function map(n, start1, stop1, start2, stop2)
    local newval = (n - start1) / (stop1 - start1) * (stop2 - start2) + start2;
    if start2 < stop2 then
        return constrain(newval, start2, stop2)
    else
        return constrain(newval, stop2, start2)
    end
end

local function drawToTextWheel(text, positionDegrees, selected)
    local positionRads = positionDegrees * (math.pi/180)
    local scale = map(math.sin(positionRads), -1, 1, 0.8, 6)
    local height = map(math.cos(positionRads), -1, 1, 20, 220)
    local variant = selected and gfx.font.kVariantBold or gfx.font.kVariantNormal
    gfx.drawTextScaled(text, screenWidth/2, height, scale, fontNontendo[variant])
end

local function getTextRotationPosition(index)
    return (pd.getCrankPosition() + index * degreesBetweenTexts) % 360
end

local function getClosestIndexToScreen()
    local relativeAngle = (-20 - pd.getCrankPosition()) % 360
    return math.round((numberOfTexts * relativeAngle) / 360) % numberOfTexts + 1
end

function pd.cranked(change, acceleratedChange)
    local newActiveIndex = getClosestIndexToScreen()
    if newActiveIndex ~= activeIndex then
        activeIndex = newActiveIndex
        clickPlayer:play()
    end
end

function pd.update()
    gfx.clear()

    for i, v in ipairs(texts) do
        drawToTextWheel(v, getTextRotationPosition(i), i == activeIndex)
    end

end
