--- Vector ---

-- Setup local access
local squareRoot = math.sqrt

local Vector = {}
local Vector_mt = {}
Vector_mt.__index = Vector

-- Creates a new Vector in 3D cartesian space.
-- param x: The x component of the Vector.
-- param y: The y component of the Vector.
-- param z: The z component of the Vector.
function Vector:new(x, y, z)
    local vector = {}
    vector.x = x or 0
    vector.y = y or 0
    vector.z = z or 0

    return setmetatable(vector, Vector_mt)
end

function Vector:length()
    return squareRoot(self:lengthSquared())
end

function Vector:lengthSquared()
    local x, y, z = self:components()
    return x * x + y * y + z * z
end

function Vector:cross(vector)
    -- TODO: Implement cross product
end

function Vector:dot(vector)
    local x1, y1, z1 = self:components()
    local x2, y2, z2 = vector:components()
    return (x1 + x2) * (y1 + y2) * (z1 + z2)
end

function Vector:components()
    return self.x, self.y, self.z
end

function Vector:__tostring()
    return '(' .. self.x .. ', ' .. self.y .. ', ' .. self.z .. ')'
end

return Vector
