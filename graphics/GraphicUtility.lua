--- GraphicUtility ---

-- Setup local access
local Camera = require('Camera')
local LineSegment = require(MATHPATH .. 'LineSegment')

local GraphicUtility = {}
GraphicUtility.__index = GraphicUtility
GraphicUtility.line = LineSegment:new()

local points = {}

local function drawLine(line, r, g, b, a)
    local _r, _g, _b, _a = love.graphics.getColor()
    love.graphics.setColor(r, g, b, a)
    --love.graphics.line(line:startPoint().x, line:startPoint().y, line:endPoint().x, line:endPoint().y)
    love.graphics.setLine(2, 'smooth')
    love.graphics.line(980, 447, 1040, 447)
    love.graphics.setColor(_r, _g, _b, _a)
end

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

function GraphicUtility.drawActor(actor)
    -- get body position
    local position = actor:body():position()

    -- position is the center of the body and by default LOVE draws image from the top left
    -- make sure LOVE draws at center
    local x = actor:sprite():getWidth() / 2
    local y = actor:sprite():getHeight() / 2

    love.graphics.draw(actor:sprite(), position.x, position.y, actor:body():orientation(), 1, 1, x, y)
end

function GraphicUtility.drawDebugLevel(level)
    for _, body in ipairs(level.engine:bodies()) do
        drawBody(body, 255, 0, 0, 255)
    end
    GraphicUtility.addPoint(GraphicUtility.line:startPoint())
    GraphicUtility.addPoint(GraphicUtility.line:endPoint())
    GraphicUtility.drawPoints(0, 255, 0, 255)
    GraphicUtility.clearPoints()
end

function GraphicUtility.drawPoints(r, g, b, a)
    local _r, _g, _b, _a = love.graphics.getColor()
    love.graphics.setColor(r, g, b, a)
    for _, p in ipairs(points) do
        love.graphics.circle('fill', p.x, p.y, 5)
    end
    love.graphics.setColor(_r, _g, _b, _a)
end

function GraphicUtility.addPoint(point)
    table.insert(points, point)
end

function GraphicUtility.clearPoints()
    points = {}
end

return GraphicUtility
