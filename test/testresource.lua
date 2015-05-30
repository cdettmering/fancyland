local ResourceManager = require('ResourceManager')
local LevelController = require('LevelController')
local Camera = require('Camera')

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

local function drawBody(body, r, g, b, a)
    for _, part in ipairs(body.parts) do
        drawShape(part:shape(), r, g, b, a)
    end
end

function testresource_load()
    testLevel = ResourceManager.loadLevel('testLevel')
    levelController = LevelController:new(testLevel)
end

function testresource_update(dt)
    levelController:update(dt)
end

function testresource_draw()
    levelController:draw()
end
