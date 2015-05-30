local Point = require(MATHPATH .. 'Point')

local MathUtil = {}
MathUtil.__index = MathUtil

function MathUtil.averagePoints(points)
    local center = Point:new()
    local count = 0
    for _, point in ipairs(points) do
        center = center + point
        count = count + 1
    end
    
    if count == 0 then
        return Point:new()
    end

    return center / count
end

return MathUtil
