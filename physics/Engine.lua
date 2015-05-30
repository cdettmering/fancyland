--- Engine ---

-- Setup local access
local Body = require(PHYSICSPATH .. 'Body')
local assert = assert

local Engine = {}
local Engine_mt = {}
Engine_mt.__index = Engine

local TAG = 'Engine'

local function defaultCollisionCallback(body1, body2, intersections)
    print('Body: ' .. body1:type() .. ' is intersecting Body: ' .. body2:type())
    for _, v in ipairs(intersections) do
        print('Part: ' .. v.part1:type() .. ' is intersecting Part: ' .. v.part2:type())
        print(v.points)
    end
end

function Engine:new()
    local engine = {}
    engine._bodies = {}
    engine.collisionCalllback = defaultCollisionCallback

    return setmetatable(engine, Engine_mt)
end

function Engine:addBody(body)
    for _, v in ipairs(self._bodies) do
        if v == body then
            return
        end
    end
    table.insert(self._bodies, body)
end

function Engine:removeBody(body)
    local index = -1
    for i, v in ipairs(self._bodies) do
        if v == body then
            index = i
        end
    end

    if index ~= -1 then
        table.remove(self._bodies, index)
    end
end

function Engine:bodies()
    return self._bodies
end

function Engine:setCollisionCallback(callback)
    assert(type(callback) == 'function', 'Engine:setCollisionCallback - Callback parameter must be a Collision Function.')
    self.collisionCallback = callback
end

function Engine:tick(dt)
    self:_applyForces(dt)
    self:_updatePositions(dt)
    self:_checkCollisions()
end

function Engine:_applyForces(dt)
    for i, body in ipairs(self._bodies) do
        for _, force in ipairs(body:forces()) do
            self._bodies[i]._velocity = self._bodies[i]._velocity + (force * dt)
        end
        self._bodies[i]._forces = {}
    end
end

function Engine:_updatePositions(dt)
    --Log.info(TAG, 'Updating body positions')
    for _, body in ipairs(self._bodies) do
        local pos = body:position() + (body:velocity() * dt)
        body:move(pos)
    end
end

function Engine:_checkCollisions()
    --Log.info(TAG, 'Checking body collisions')
    if self.collisionCallback ~= nil then
        -- check each body against all other _bodies
        for _, body1 in ipairs(self._bodies) do
            for _, body2 in ipairs(self._bodies) do
                if body1 ~= body2 then
                    local intersections = body1:isIntersecting(body2)
                    if intersections then
                        self.collisionCallback(body1, body2, intersections)
                    end
                end
            end
        end
    end
end

return Engine
