--- FileManager ---

-- Setup local access
local LayerFile = require(FILEPATH .. 'LayerFile')
local EnemyFile = require(FILEPATH .. 'EnemyFile')
local EnemyImplementationFile = require(FILEPATH .. 'EnemyImplementationFile')
local EnemyMapFile = require(FILEPATH .. 'EnemyMapFile')
local LevelFile = require(FILEPATH .. 'LevelFile')
local Enemy = require(DATATYPEPATH .. 'Enemy')

local FileManager = {}
FileManager.__index = FileManager

local TAG = 'FileManager'

local function loadFile(file)
    Log.info(TAG, 'Loading file ' .. file)
    return love.filesystem.load(file)()
end

function FileManager.loadLayerFile(layerFile)
    local f = loadFile(layerFile)
    return LayerFile:new(f.textures, f.speed)
end

function FileManager.loadEnemyMapFile(mapFile)
    local f = loadFile(mapFile)
    return EnemyMapFile:new(f.dictionary, f.enemies)
end

function FileManager.loadEnemyFile(enemyFile)
    local f = loadFile(enemyFile)
    return EnemyFile:new(f.sprite, f.body, f.type)
end

function FileManager.loadEnemyImplementationFile(enemyImplementationFile)
    local f = loadFile(enemyImplementationFile)
    return EnemyImplementationFile:new(f.update, f.draw, f.onClick, f.onCollision) 
end

function FileManager.loadLevelFile(levelFile)
    local f = loadFile(levelFile)
    return LevelFile:new(f.startPoint, f.finishLine, f.timeToComplete, f.enemyFile, f.terrainFile, f.backgroundLayerFile, f.backForegroundLayerFile, f.functionalLayerFile, f.foregroundLayerFile)
end

return FileManager
