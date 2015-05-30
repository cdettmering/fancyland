--- LineSegment ---

-- Setup local access
local Point = require(MATHPATH .. 'Point')
local Vector = require(MATHPATH .. 'Vector')

local LineSegment = {}
local LineSegment_mt = {}
LineSegment_mt.__index = LineSegment

-- Creates a new LineSegment
-- param p1: The start Point of the LineSegment, where Point is created by Point:new
-- param p2: The end Point of the LineSegment, where Point is created by Point:new
-- return: LineSegment described by start = p1 and end = p2
function LineSegment:new(p1, p2)
    local segment = {}
    segment.p1 = p1 or Point:new()
    segment.p2 = p2 or Point:new()

    return setmetatable(segment, LineSegment_mt)
end

-- Gets the start point of the LineSegment.
-- return: Point object that is the start point.
function LineSegment:startPoint()
    return self.p1
end

-- Gets the end point of the LineSegment.
-- return: Point object that is the end point.
function LineSegment:endPoint()
    return self.p2
end

function LineSegment:vector()
    local vector = self.p2 - self.p1
    return Vector:new(vector.x, vector.y, vector.z)
end

-- Checks if self intersects with lineSegment
-- param lineSegment: The other LineSegment to check for intersection with.
-- return: The Point of intersection, or nil if the lines do not intersect.
function LineSegment:isIntersecting(lineSegment)
    -- Let the equation for LineSegment1 and LineSegment2 be L1 and L2 respectively.
    -- L1 = P1 + u1(P2 - P1)
    -- L2 = P3 + u2(P4 - P3)
    -- where, PX is a point that defines the line segments and ux is an unknown value.
    --
    -- To find the intersection L1x = L2x and L1y = L2y and gives us 2 equations:
    -- x1 + u1(x2 - x1) = x3 + u2(x4 - x3)
    -- y1 + u1(y2 - y1) = y3 + u2(y4 - y3)
    --
    -- after solving the equations for u1 and u2:
    --
    -- ua = (x2 - x1)(y1 - y3) - (y2 - y1)(x1 - x3) /
    --      (y4 - y3)(x2 - x1) - (x4 - x3)(y2 - y1)
    --
    -- ub = (x2 - x1)(y1 - y3) - (y2 - y1)(x1 - x3) /
    --      (y4 - y3)(x2 - x1) - (x4 - x3)(y2 - y1)
    --
    -- Notice that both of the denominators are the same.
    --
    -- If the denominator is 0 then the lines are parallel.
    -- If both of the numerators are 0 then the lines are coincident (one inside the other)
    --
    -- Otherwise the lines are intersecting, to make sure it is intersecting on the segment
    -- and not the infinite line, ua or ub need to be 0 < ua < 1 or 0 < ub < 1.

    local x1 = self.p1.x
    local x2 = self.p2.x
    local y1 = self.p1.y
    local y2 = self.p2.y
    local x3 = lineSegment.p1.x
    local x4 = lineSegment.p2.x
    local y3 = lineSegment.p1.y
    local y4 = lineSegment.p2.y

    local denom = ((y4 - y3) * (x2 - x1)) - ((x4 - x3) * (y2 - y1))

    if demon == 0 then
        return nil
    end

    local ua = ((x4 - x3) * (y1 - y3)) - ((y4 - y3) * (x1 - x3))
    local ub = ((x2 - x1) * (y1 - y3)) - ((y2 - y1) * (x1 - x3))

    -- lines are coincident
    if ua == 0 and ub == 0 then
        return nil
    end

    ua = ua / denom
    ub = ub / denom

    if (ua > 0 and ua < 1) and
       (ub > 0 and ub < 1) then
        return Point:new(x1 + (ua * (x2 - x1)), y1 + (ua * (y2 - y1)))
    else
        return nil
    end
end

-- Returns a string representation of the LineSegment
local function toString(line)
    return '(' .. line.p1.x .. ',' .. line.p1.y .. ',' .. line.p2.x .. ',' .. line.p2.y .. ')'
end

LineSegment_mt.__tostring = toString

return LineSegment
