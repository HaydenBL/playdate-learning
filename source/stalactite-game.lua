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
local stalactiteTopLine = geo.lineSegment.new(sideGroundWidth, 0, sideGroundWidth+gapWidth, 0)

local stalactiteOriginalLeftLine <const> = stalactiteLeftLine:copy()
local stalactiteOriginalRightLine <const> = stalactiteRightLine:copy()
local stalactiteOriginalBottomLine <const> = stalactiteBottomLine:copy()
local stalactiteOriginalTopLine <const> = stalactiteTopLine:copy()

local function drawStalactite()
	gfx.drawLine(stalactiteLeftLine)
	gfx.drawLine(stalactiteRightLine)
	gfx.drawLine(stalactiteBottomLine)
	gfx.drawLine(stalactiteTopLine)
end

local fallAnimation

local function dropStalactite()
	fallAnimation = Animator.new(1200, 0, screenHeight-baseGroundHeight, pd.easingFunctions.outBounce)
end

local function offsetLineY(current, original, amount)
	current.y1 = original.y1+amount;
	current.y2 = original.y2+amount;
end

local function updateStalactite()
	if fallAnimation ~= nil and not fallAnimation:ended() then
		offsetLineY(stalactiteLeftLine, stalactiteOriginalLeftLine, fallAnimation:currentValue())
		offsetLineY(stalactiteRightLine, stalactiteOriginalRightLine, fallAnimation:currentValue())
		offsetLineY(stalactiteBottomLine, stalactiteOriginalBottomLine, fallAnimation:currentValue())
		offsetLineY(stalactiteTopLine, stalactiteOriginalTopLine, fallAnimation:currentValue())
	end

end

local dropped = false;
function playdate.AButtonDown()
	if not dropped then
		dropStalactite()
		dropped = true
	end
end

function pd.update()
	gfx.clear()

	updateStalactite()
	drawGround()
	drawStalactite()
end
