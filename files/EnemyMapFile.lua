--- EnemyMapFile ---

-- Setup local access
local EnemyMapFile = {}
local EnemyMapFile_mt = {}
EnemyMapFile_mt.__index = EnemyMapFile

function EnemyMapFile:new(dictionary, enemies)
    local map = {}
    map.dictionary = dictionary
    map.enemies = enemies
    return setmetatable(map, EnemyMapFile_mt)
end

local function toString(f)
    local str = '[EnemyMapFile[Dictionary: '
    for k, v in pairs(f.dictionary) do
        str = str .. '(Type: ' .. k .. ', File: ' .. v .. ')'
    end
    str = str .. '][Enemies: '
    for i, v in ipairs(f.enemies) do
        str = str .. tostring(v)
        if i < #f.enemies then
            str = str .. ', '
        end
    end
    str = str .. ']]'

    return str
end

EnemyMapFile_mt.__tostring = toString

return EnemyMapFile
