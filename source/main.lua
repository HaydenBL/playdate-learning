import "CoreLibs/graphics"

local pd = playdate
local gfx = pd.graphics

-- yoinked from https://devforum.play.date/t/add-a-drawtextscaled-api-see-code-example/7108
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

function pd.update()
    gfx.clear()

    local w, h = playdate.display.getSize()
    local crankPosition = pd.getCrankPosition()
    local crankRads = math.sin((crankPosition+90) * (math.pi/180))
    gfx.drawTextScaled("Hello", w/2, h/2, map(crankRads, -1, 1, 0.8, 6), gfx.getSystemFont())
end
