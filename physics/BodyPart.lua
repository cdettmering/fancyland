--- BodyPart ---

-- Setup local access
local Shape = require(MATHPATH .. 'Shape')
local assert = assert

local BodyPart = {}
local BodyPart_mt = {}
BodyPart_mt.__index = BodyPart

-- Creates a new BodyPart.
-- param shape: The Shape of the BodyPart created with Shape:new.
-- param partType: String identifier for client use.
function BodyPart:new(partType, shape)
    assert(shape ~= nil, 'BodyPart:new - Shape parameter cannot be nil')
    local part = {}
    part._shape = shape
    part._type = partType or 'BODYPART'

    return setmetatable(part, BodyPart_mt)
end

-- Gets the type of this BodyPart
-- return: String representing the type of this BodyPart.
function BodyPart:type()
    return self._type
end

-- Gets the underlying shape of this BodyPart
-- return: Shape object that defines the shape of this BodyPart.
function BodyPart:shape()
    return self._shape
end

local function toString(part)
    return 'BodyPart[Type: ' .. part._type .. ' Shape: ' .. tostring(part._shape) .. ']'
end

BodyPart_mt.__tostring = toString

return BodyPart
