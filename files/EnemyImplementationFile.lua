--- EnemyImplementationFile ---

-- Setup local access
local EnemyImplementationFile = {}
local EnemyImplementationFile_mt = {}
EnemyImplementationFile_mt.__index = EnemyImplementationFile

function EnemyImplementationFile:new(update, draw, onClick, onCollision)
    local enemyImplementationFile = {}
    enemyImplementationFile.update = update
    enemyImplementationFile.draw = draw
    enemyImplementationFile.onClick = onClick
    enemyImplementationFile.onCollision = onCollision

    return setmetatable(enemyImplementationFile, EnemyImplementationFile_mt)
end

return EnemyImplementationFile 
