--- EnemyList ---

-- Setup local access
local EnemyList = {}
local EnemyList_mt = {}
EnemyList_mt.__index = EnemyList

function EnemyList:new(enemies)
    local list = {}
    list._enemies = enemies

    return setmetatable(list, EnemyList_mt)
end

function EnemyList:enemies()
    return self._enemies
end

return EnemyList
