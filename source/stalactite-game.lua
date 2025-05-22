import "CoreLibs/animator"
import "CoreLibs/easing"

local pd = playdate
local gfx = pd.graphics
local geo = pd.geometry
local Animator = pd.graphics.animator

local screenWidth, screenHeight = playdate.display.getSize()

local gapWidth = 60
local baseGroundHeight = 100
local pitDepth = 30
local sideGroundWidth = (screenWidth - gapWidth)/2

local leftSideGroundLine = geo.lineSegment.new(0, screenHeight-baseGroundHeight, sideGroundWidth, screenHeight-baseGroundHeight)
local rightSideGroundLine = geo.lineSegment.new(sideGroundWidth+gapWidth, screenHeight-baseGroundHeight, screenWidth, screenHeight-baseGroundHeight)

local pitAnglePoint1 = math.random(0, 60)
local pitAnglePoint2 = math.random(0, 60)

local pitBottomLine = geo.lineSegment.new(sideGroundWidth, screenHeight-baseGroundHeight+pitDepth+pitAnglePoint1, sideGroundWidth+gapWidth, screenHeight-baseGroundHeight+pitDepth+pitAnglePoint2)
local pitLeftSideLine = geo.lineSegment.new(sideGroundWidth, screenHeight-baseGroundHeight, sideGroundWidth, screenHeight-baseGroundHeight+pitDepth+pitAnglePoint1)
local pitRightSideLine = geo.lineSegment.new(sideGroundWidth+gapWidth, screenHeight-baseGroundHeight+pitDepth+pitAnglePoint2, sideGroundWidth+gapWidth, screenHeight-baseGroundHeight)

local function drawGround()
	gfx.drawLine(leftSideGroundLine)
	gfx.drawLine(rightSideGroundLine)

	gfx.drawLine(pitLeftSideLine)
	gfx.drawLine(pitBottomLine)
	gfx.drawLine(pitRightSideLine)
end

function pd.update()
	gfx.clear()
	
	drawGround()
end
