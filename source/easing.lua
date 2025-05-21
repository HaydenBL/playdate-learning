import "CoreLibs/animator"
import "CoreLibs/easing"

local pd = playdate
local gfx = pd.graphics
local geo = pd.geometry
local Animator = pd.graphics.animator

local posX, posY

local points = {
	geo.point.new(20, 20),
	geo.point.new(350, 20),
	geo.point.new(350, 200),
	geo.point.new(20, 200),
}

local currentPosition = 1

local function getAnimation()
	return Animator.new(2000, points[currentPosition], points[currentPosition < table.getsize(points) and currentPosition+1 or 1], pd.easingFunctions.outElastic)
end

local animation = getAnimation()

function pd.update()
	gfx.clear()
	print(currentPosition)

	if not animation:ended() then
		posX = animation:currentValue().x
		posY = animation:currentValue().y
	else
		currentPosition = currentPosition < table.getsize(points) and currentPosition+1 or 1
		animation = getAnimation()
	end

	gfx.drawText("Sup", posX, posY)
end
