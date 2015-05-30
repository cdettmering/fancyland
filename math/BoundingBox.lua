--- BoundingBox ---

-- Setup local access
local Point = require(MATHPATH .. 'Point')

local BoundingBox = {}
local BoundingBox_mt = {}
BoundingBox_mt.__index = BoundingBox

function BoundingBox:new(min, max)
    local bb = {}
    bb._min = min or Point:new()
    bb._max = max or Point:new()

    return setmetatable(bb, BoundingBox_mt)
end

function BoundingBox.fromShape(shape)
    local pts = shape:points()
    if #pts <= 0 then
        return BoudningBox:new()
    end
    local min = pts[1]
    local max = pts[1]
    for _, pt in ipairs(pts) do
        if pt <= min then
            min = pt
        end
        if pt >= max then
            max = pt
        end
    end
    return BoundingBox:new(min, max)
end

function BoundingBox:min()
    return self._min
end

function BoundingBox:max()
    return self._max
end

function BoundingBox:height()
    return self:max().y - self:min().y
end

function BoundingBox:width()
    return self:max().x - self:min().x
end

function BoundingBox:center()
    local x = self:width() / 2
    local y = self:height() / 2
    return self:min() + Point:new(x, y)
end

return BoundingBox
