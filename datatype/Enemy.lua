--- Enemy ---

-- Setup local access
local Point = require(MATHPATH .. 'Point')

local Enemy = {}
local Enemy_mt = {}
Enemy_mt.__index = Enemy

-- Creates a new Enemy
-- param position: The position of the Enemy.
-- param orientation: The orientation of the Enemy (radians).
-- param enemyType: The string identifier for this enemy type.
function Enemy:new(position, orientation, enemyType)
    local enemy = {}
    enemy.position = position or Point:new()
    enemy.orientation = orientation or 0
    enemy.enemyType = enemyType or 'ENEMY'

    return setmetatable(enemy, Enemy_mt)
end

local function toString(e)
    return '[Enemy[Position: ' .. tostring(e.position) .. '][Orientation: ' .. tostring(e.orientation) .. '][Type: ' .. e.enemyType .. ']'
end

Enemy_mt.__tostring = toString

return Enemy
