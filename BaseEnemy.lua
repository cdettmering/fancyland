--- BaseEnemy ---

-- Setup local access
local BaseEnemy = {}
local BaseEnemy_mt = {}
BaseEnemy_mt.__index = BaseEnemy

function BaseEnemy:new(actor, enemyType, updateFunction, drawFunction, clickFunction, collisionFunction)
    local enemy = {}
    enemy._actor = actor
    enemy.enemyType = enemyType
    enemy.updateFunction = updateFunction
    enemy.drawFunction = drawFunction
    enemy.onClickFunction = clickFunction
    enemy.onCollisionFunction = collisionFunction

    return setmetatable(enemy, BaseEnemy_mt)
end

function BaseEnemy:update(dt)
    self.updateFunction(self, dt)
end

function BaseEnemy:draw()
    self.drawFunction(self)
end

function BaseEnemy:onCollision(body1, body2, intersections)
    self.onCollisionFunction(self, body1, body2, intersections)
end

function BaseEnemy:onClick(point)
    self.onClickFunction(self, point)
end

function BaseEnemy:type()
    return self.enemyType
end

function BaseEnemy:actor()
    return self._actor
end

return BaseEnemy
