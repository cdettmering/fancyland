--- Layer ---

-- Setup local access
local Layer = {}
local Layer_mt = {}
Layer_mt.__index = Layer

-- Creates a new Layer
-- param textures: A list of Image objects that represents the layer panoramic.
-- param speed: The speed the panoramic scrolls by, default is 1.
function Layer:new(textures, speed)
    local layer = {}
    layer.textures = textures
    layer.speed = speed or 1

    return setmetatable(layer, Layer_mt)
end

local function toString(l)
    return '[Layer[Speed: ' .. tostring(l.speed) .. ']]'
end

Layer_mt.__tostring = toString

return Layer
