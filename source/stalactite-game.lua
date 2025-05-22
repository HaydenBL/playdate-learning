import "CoreLibs/animator"
import "CoreLibs/easing"

local pd = playdate
local gfx = pd.graphics
local geo = pd.geometry
local Animator = pd.graphics.animator

local screenWidth, screenHeight = playdate.display.getSize()

-- to match up shape of pit with stalactite
local pitAnglePoint1 = math.random(0, 60)
local pitAnglePoint2 = math.random(0, 60)


local gapWidth = 60
local baseGroundHeight = 100
local pitDepth = 30
local sideGroundWidth = (screenWidth - gapWidth)/2

local leftSideGroundLine = geo.lineSegment.new(0, screenHeight-baseGroundHeight, sideGroundWidth, screenHeight-baseGroundHeight)
local rightSideGroundLine = geo.lineSegment.new(sideGroundWidth+gapWidth, screenHeight-baseGroundHeight, screenWidth, screenHeight-baseGroundHeight)

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

local stalactiteLeftLine = geo.lineSegment.new(sideGroundWidth, 0, sideGroundWidth, pitDepth+pitAnglePoint1)
local stalactiteRightLine = geo.lineSegment.new(sideGroundWidth+gapWidth, 0, sideGroundWidth+gapWidth, pitDepth+pitAnglePoint2)
local stalactiteBottomLine = geo.lineSegment.new(sideGroundWidth, pitDepth+pitAnglePoint1, sideGroundWidth+gapWidth, pitDepth+pitAnglePoint2)

local function drawStalactite()
	gfx.drawLine(stalactiteLeftLine)
	gfx.drawLine(stalactiteRightLine)
	gfx.drawLine(stalactiteBottomLine)
end

function pd.update()
	gfx.clear()

	drawGround()
	drawStalactite()
end
