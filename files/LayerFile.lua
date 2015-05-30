--- LayerFile ---

-- Setup local access
local LayerFile = {}
local LayerFile_mt = {}
LayerFile_mt.__index = LayerFile

function LayerFile:new(textures, speed)
    local layerFile = {}
    layerFile.textures = textures
    layerFile.speed = speed or 1

    return setmetatable(layerFile, LayerFile_mt)
end

local function toString(f)
    local str = '[Layer[Speed: ' .. tostring(f.speed) .. '][Textures: '
    for i, t in ipairs(f.textures) do
        str = str .. t
        if i < #f.textures then
            str = str .. ', '
        end
    end
    str = str .. ']]'
    return str
end

LayerFile_mt.__tostring = toString

return LayerFile
