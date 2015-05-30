--- EnemyFile ---

-- Setup local access
local EnemyFile = {}
local EnemyFile_mt = {}
EnemyFile_mt.__index = EnemyFile

function EnemyFile:new(sprite, body, enemyType)
    local enemyFile = {}
    enemyFile.sprite = sprite
    enemyFile.body = body
    enemyFile.type = enemyType

    return setmetatable(enemyFile, EnemyFile_mt)
end

return EnemyFile
