--- Cursor ---

-- Setup local access
local Point = require(MATHPATH .. 'Point')

local Cursor = {}
Cursor.__index = Cursor

Cursor._position = Point:new()

local callback = nil

function Cursor.click(point)
    callback(point)
end

function Cursor.move(point)
    Cursor._position = point
end

function Cursor.draw()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(0, 0, 255, 255)
    love.graphics.circle('fill', Cursor._position.x, Cursor._position.y, 5)
    love.graphics.setColor(r, g, b, a)
end

function Cursor.setClickCallback(onClick)
    callback = onClick
end

return Cursor
