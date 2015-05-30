 --- LevelFile ---
 
 -- Setup local access
 local LevelFile = {}
 local LevelFile_mt = {}
 LevelFile_mt.__index = LevelFile

 function LevelFile:new(startPoint,
                    finishLine,
                    timeToComplete,
                    enemyMapFile,
                    terrainFile,
                    backgroundLayerFile,
                    backForegroundLayerFile,
                    functionalLayerFile,
                    foregroundLayerFile)

    local levelFile = {}
    levelFile.startPoint = startPoint
    levelFile.finishLine = finishLine
    levelFile.timeToComplete = timeToComplete
    levelFile.enemyMapFile = enemyMapFile
    levelFile.terrainFile = terrainFile
    levelFile.backgroundLayerFile = backgroundLayerFile
    levelFile.backForegroundLayerFile = backForegroundLayerFile
    levelFile.functionalLayerFile = functionalLayerFile
    levelFile.foregroundLayerFile = foregroundLayerFile

    return setmetatable(levelFile, LevelFile_mt)
end

local function toString(f)
    return '[Level[StartPoint: ' .. tostring(f.startPoint) .. '][FinishLine: ' .. tostring(f.finishLine) ..
            '][TimeToComplete: ' .. tostring(f.timeToComplete) .. '][EnemyMapFile: ' .. f.enemyMapFile ..
            '][TerrainFile: ' .. f.terrainFile .. '][BackgroundLayerFile: ' .. f.backgroundLayerFile ..
            '][BackForegroundLayerFile: ' .. f.backForegroundLayerFile .. '][FunctionalLayerFile: ' ..
            f.functionalLayerFile .. '][ForegroundLayerFile: ' .. f.foregroundLayerFile .. ']]'
end

LevelFile_mt.__tostring = toString

return LevelFile
