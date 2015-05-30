--- Point ---

-- Setup local access
local Point = {}
local Point_mt = {}
Point_mt.__index = Point

-- Creates a new Point in 3D Cartesian space
-- param x: The x coordinate, default is 0
-- param y: the y coordinate, default is 0
-- param z: the z coordinate, default is 0
-- return: a new Point at (x, y, z)
function Point:new(x, y, z)
    local point = {}
    point.x = x or 0
    point.y = y or 0
    point.z = z or 0

    return setmetatable(point, Point_mt)
end

-- Clones the data from the point
-- return: a new Point with the cloned data
function Point:clone()
    return Point:new(self.x, self.y, self.z)
end

-- Gets the x, y, z components of this point
-- return: x, y, z
function Point:components()
    return self.x, self.y, self.z
end

-- Returns a string representation of the Point, this meta function is
-- automatically called by lua for coercion.
local function toString(a)
    return 'Point(' .. a.x .. ', ' .. a.y .. ', ' .. a.z .. ')'
end

-- Adds 2 Points
-- param a: Point a
-- param b: Point b
-- return: Point at (a.x + b.x, a.y + b.y, a.z + b.z)
local function add(a, b)
    --print('A: ' .. tostring(a) .. ' B: ' .. tostring(b))
    return Point:new(a.x + b.x, a.y + b.y, a.z + b.z)
end

-- Subtracts 2 Points
-- param a: Point a
-- param b: Point b
-- return: Point at (a.x - b.x, a.y - b.y, a.z - b.z)
local function subtract(a, b)
    return Point:new(a.x - b.x, a.y - b.y, a.z - b.z)
end

-- Divides a Point by a scalar
-- param point: The starting Point
-- param scalar: The scalar to divide each component of the Point by.
-- return: Point at (point.x / scalar, point.y / scalar, point.z / scalar)
local function divide(point, scalar)
    return Point:new(point.x / scalar, point.y / scalar, point.z / scalar)
end

-- Multiplies a Point by a scalar
-- param point: The starting Point
-- param scalar: The scalar to multiply each component of the Point by.
-- return: Point at (point.x * scalar, point.y * scalar, point.z * scalar)
local function multiply(point, scalar)
    return Point:new(point.x * scalar, point.y * scalar, point.z * scalar)
end

-- Negates the Point
-- param point: The Point to negate
-- return: A new Point(-point.x, -point.y, -point.z)
local function negate(point)
    return Point:new(-point.x, -point.y, -point.z)
end

local function lessThan(a, b)
    return a.x < b.x and a.y < b.y and a.z < b.z
end

local function lessThanOrEqual(a, b)
    return a.x <= b.x and a.y <= b.y and a.z <= b.z
end

local function greaterThan(a, b)
    return a.x > b.x and a.y > b.y and a.z > b.z
end

local function greaterThanOrEqual(a, b)
    return a.x >= b.x and a.y >= b.y and a.z >= b.z
end

-- Setup metamethods for automatic addition, subtraction, and divsion using 
-- the '+', '-', and '/' operators
Point_mt.__add = add
Point_mt.__sub = subtract
Point_mt.__div = divide
Point_mt.__mul = multiply
Point_mt.__unm = negate
Point_mt.__lt = lessThan
Point_mt.__le = lessThanOrEqual
Point_mt.__gt = greaterThan
Point_mt.__ge = greaterThanOrEqual
Point_mt.__tostring = toString

return Point
