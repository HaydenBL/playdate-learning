import "CoreLibs/graphics"

local pd = playdate
local gfx = pd.graphics

local fontPathsNontendo = {
    [playdate.graphics.font.kVariantNormal] = "fonts/Nontendo/Nontendo-Light",
    [playdate.graphics.font.kVariantBold] = "fonts/Nontendo/Nontendo-Bold"
}
local fontNontendo = gfx.font.newFamily(fontPathsNontendo)

local activeIndex = 1;
local texts = {
    "Knack 3",
    "Knack 4",
    "Knack 5",
    "Knack 6"
}

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

local function drawToTextWheel(text, offsetDegrees, selected)
    local w, h = playdate.display.getSize()
    local crankPosition = pd.getCrankPosition() + offsetDegrees
    local crankRads = (crankPosition) * (math.pi/180)
    local scale = map(math.sin(crankRads), -1, 1, 0.8, 6)
    local height = map(math.cos(crankRads), -1, 1, 20, 220)
    local variant = selected and gfx.font.kVariantBold or gfx.font.kVariantNormal
    gfx.drawTextScaled(text, w/2, height, scale, fontNontendo[variant])
end

function pd.update()
    gfx.clear()

    for i, v in ipairs(texts) do
        drawToTextWheel(v, i*90, i == activeIndex)
    end
    
    -- drawToTextWheel("knack 4", 180)
    -- drawToTextWheel("knack 5", 270)
    -- drawToTextWheel("knack 6", 0)
end
