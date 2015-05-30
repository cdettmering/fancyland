 --- Level ---
 
 -- Setup local access
 local Level = {}
 local Level_mt = {}
 Level_mt.__index = Level

 function Level:new(startPoint,
                    finishLine,
                    timeToComplete,
                    enemies,
                    terrain,
                    backgroundLayer,
                    backForegroundLayer,
                    functionalLayer,
                    foregroundLayer)

    local level = {}
    level.startPoint = startPoint
    level.finishLine = finishLine
    level.timeToComplete = timeToComplete
    level.enemyList = enemies
    level.terrain = terrain
    level.backgroundLayer = backgroundLayer
    level.backForegroundLayer = backForegroundLayer
    level.functionalLayer = functionalLayer
    level.foregroundLayer = foregroundLayer

    return setmetatable(level, Level_mt)
end

return Level
