local assert = assert
local Point = require(MATHPATH .. 'Point')
local Shape = require(MATHPATH .. 'Shape')
local pi = math.pi

local angle  = pi / 2
local right = true
local rotatingSquare = Shape:new(Point:new(5, 30, 0),
                                 Point:new(55, 30, 0),
                                 Point:new(55, 80, 0),
                                 Point:new(5, 80, 0))

local translatingSquare = Shape:new(Point:new(5, 130, 0),
                                    Point:new(55, 130, 0),
                                    Point:new(55, 180, 0),
                                    Point:new(5, 180, 0))

local function drawShape(shape, r, g, b, a)
    local vertices = {}
    for _, line in ipairs(shape.lines) do
        table.insert(vertices, line.p1.x)
        table.insert(vertices, line.p1.y)
        table.insert(vertices, line.p2.x)
        table.insert(vertices, line.p2.y)
    end
    local _r, _g, _b, _a = love.graphics.getColor()
    love.graphics.setColor(r, g, b, a)
    love.graphics.polygon('fill', vertices)
    love.graphics.setColor(_r, _g, _b, _a)
end


function mathtest_update(dt)
    angle = angle + pi * dt
    rotatingSquare:rotate(angle)

    local transCenter = translatingSquare:center()
    if transCenter.x >= 1000 then
        right = false
    elseif transCenter.x <= 30 then
        right = true
    end

    if right then
        transCenter = transCenter + Point:new(1)
    else
        transCenter = transCenter - Point:new(1)
    end
    translatingSquare:translate(transCenter)
end

function mathtest_draw()
    love.graphics.print('Rotation', 5, 5)
    love.graphics.print('Translation', 5, 100)
    drawShape(rotatingSquare, 255, 0, 0, 255)
    drawShape(translatingSquare, 255, 0, 0, 255)
end
