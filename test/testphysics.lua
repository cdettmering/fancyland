local Engine = require(PHYSICSPATH .. 'Engine')
local BodyPart = require(PHYSICSPATH .. 'BodyPart')
local Body = require(PHYSICSPATH .. 'Body')
local Shape = require(MATHPATH .. 'Shape')
local Point = require(MATHPATH .. 'Point')

local collidePoints = {}
local centerPoints = {}
local drawCollide = false

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

local function drawPoints(r, g, b, a)
    local _r, _g, _b, _a = love.graphics.getColor()
    love.graphics.setColor(r, g, b, a)
    if drawCollide then
        for _, point in ipairs(collidePoints) do
            love.graphics.circle('fill', point.x, point.y, 5)
        end
        drawCollide = false
    end
    for _, point in ipairs(centerPoints) do
        love.graphics.circle('fill', point.x, point.y, 5)
    end
    love.graphics.setColor(_r, _g, _b, _a)
end

local function collision(body1, body2, intersections)
    drawCollide = true
    for _, element in ipairs(intersections) do
        collidePoints = element.points
    end
end

function loadTest()
-- create a square
square = Body:new('squareman',
                  BodyPart:new(
                    'sqaure',
                    Shape:new(
                        Point:new(5, 30, 0),
                        Point:new(55, 30, 0),
                        Point:new(55, 80, 0),
                        Point:new(5, 80, 0))
                        ))

-- create a triangle
triangle = Body:new('triangleman',
                    BodyPart:new(
                        'triangle',
                        Shape:new(
                            Point:new(30, 150, 0),
                            Point:new(55, 175, 0),
                            Point:new(5, 175, 0))
                            ))

-- create ground
ground = Body:new('ground',
                  BodyPart:new(
                    'ground',
                    Shape:new(
                        Point:new(0, 500, 0),
                        Point:new(1280, 500, 0),
                        Point:new(1280, 720, 0),
                        Point:new(0, 720, 0))
                        ))

-- falling object
object = Body:new('object',
                    BodyPart:new(
                        'object',
                        Shape:new(
                            Point:new(640, 250, 0),
                            Point:new(665, 225, 0),
                            Point:new(615, 225, 0))
                            ))
world = Engine:new()
world:setCollisionCallback(collision)
world:addBody(square)
world:addBody(triangle)
world:addBody(ground)
world:addBody(object)

-- apply constant force to triangle going right
square:applyForce(Point:new(100, 0, 0))
triangle:applyForce(Point:new(50, 0, 0))
object:applyForce(Point:new(0, 50, 0))

end

function updateTest(dt)
    world:tick(dt)
    centerPoints = {}
    for _, body in ipairs(world:bodies()) do
        table.insert(centerPoints, body:position())
    end
end

function drawTest()
    love.graphics.print('Large Force', 5, 5)
    love.graphics.print('Small Force', 5, 100)
    drawBody(square, 255, 0, 0, 255)
    drawBody(triangle, 0, 0, 255, 255)
    drawBody(ground, 255, 0, 0, 255)
    drawBody(object, 0, 0, 255, 255)
    drawPoints(255, 255, 0, 255)
end
