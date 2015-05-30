--- ResourceManager ---

-- Setup local access
local Layer = require(DATATYPEPATH .. 'Layer')
local Enemy = require(DATATYPEPATH .. 'Enemy')
local EnemyList = require(DATATYPEPATH .. 'EnemyList')
local Terrain = require(DATATYPEPATH .. 'Terrain')
local Level = require(DATATYPEPATH .. 'Level')
local FileManager = require(FILEPATH .. 'FileManager')
local BaseEnemy = require('BaseEnemy')
local Actor = require('Actor')

local ResourceManager = {}
ResourceManager.__index = ResourceManager

local TAG = 'ResourceManager'
local spriteCache = {}

local function loadFile(file)
    Log.info(TAG, 'Loading file ' .. file)
    return love.filesystem.load(file)()
end

-- core loading directories
local function getRootDirectory()
    return CONTENTPATH
end

local function getTextureDirectory()
    return CONTENTPATH .. 'textures/'
end

local function getLevelDirectory()
    return CONTENTPATH .. 'levels/'
end

-- level loading directories
local function getRootLevelDirectory(levelName)
    return getLevelDirectory() .. levelName .. '/'
end

local function getLevelFile(levelName)
    return getRootLevelDirectory(levelName) .. 'main.level'
end

local function getTextureLevelDirectory(levelName)
    return getRootLevelDirectory(levelName) .. 'textures/'
end

local function getEnemyLevelDirectory(levelName)
    return getRootLevelDirectory(levelName) .. 'enemies/'
end

local function getEnemyImplementationLevelDirectory(levelName)
    return getEnemyLevelDirectory(levelName) .. 'implementation/'
end

function ResourceManager.loadLayer(layerFile, levelName)
    -- load textures
    local t = {}
    for _, texture in ipairs(layerFile.textures) do
        local sprite = ResourceManager.loadSprite(texture, levelName)
        table.insert(t, sprite)
    end
    return Layer:new(t, layerFile.speed)
end

function ResourceManager.loadTerrain(terrainFile)
    return Terrain:new(loadFile(terrainFile))
end

function ResourceManager.loadSprite(spriteFile, levelName)
    Log.info(TAG, 'Loading sprite ' .. spriteFile)
    local directory = ''
    if levelName == nil then
        -- not loading sprite for a level
        directory = getTextureDirectory()
    else
        directory = getTextureLevelDirectory(levelName)
    end
    if spriteCache[spriteFile] == nil then
        spriteCache[spriteFile] = love.graphics.newImage(directory .. spriteFile)
    end
    return spriteCache[spriteFile]
end

function ResourceManager.loadEnemy(enemyFile, enemyImplementationFile, levelName)
    local sprite = ResourceManager.loadSprite(enemyFile.sprite, levelName)
    local actor = Actor:new(sprite, enemyFile.body)
    return BaseEnemy:new(actor, enemyFile.type, enemyImplementationFile.update, enemyImplementationFile.draw, enemyImplementationFile.onClick, enemyImplementationFile.onCollision)
end

function ResourceManager.loadEnemyMap(enemyMapFile, levelName)
    local enemyDirectory = getEnemyLevelDirectory(levelName)
    local enemyImplementationDirectory = getEnemyImplementationLevelDirectory(levelName)
    local enemies = {}
    for _, enemy in ipairs(enemyMapFile.enemies) do
        -- load base enemy
        local enemyFile = FileManager.loadEnemyFile(enemyDirectory .. enemyMapFile.dictionary[enemy.type])
        -- load implementation
        local enemyImplementationFile = FileManager.loadEnemyImplementationFile(enemyImplementationDirectory .. enemyMapFile.dictionary[enemy.type])
        local baseEnemy = ResourceManager.loadEnemy(enemyFile, enemyImplementationFile, levelName)

        -- move actor to position and orientation
        baseEnemy:actor():body():move(enemy.position)
        baseEnemy:actor():body():rotate(enemy.orientation)

        -- add to list
        table.insert(enemies, baseEnemy)
    end

    return EnemyList:new(enemies)
end

function ResourceManager.loadLevel(levelName)
    Log.info(TAG, 'Loading level ' .. levelName)
    -- This returns all subsequent files as strings, not file structures
    local levelFile = FileManager.loadLevelFile(getLevelFile(levelName))

    -- Load file structures
    local enemyMapFile = FileManager.loadEnemyMapFile(getRootLevelDirectory(levelName) .. levelFile.enemyMapFile)
    local backgroundLayerFile = FileManager.loadLayerFile(getRootLevelDirectory(levelName) .. levelFile.backgroundLayerFile)
    local backForegroundLayerFile = FileManager.loadLayerFile(getRootLevelDirectory(levelName) .. levelFile.backForegroundLayerFile)
    local functionalLayerFile = FileManager.loadLayerFile(getRootLevelDirectory(levelName) .. levelFile.functionalLayerFile)
    local foregroundLayerFile = FileManager.loadLayerFile(getRootLevelDirectory(levelName) .. levelFile.foregroundLayerFile)

    -- Expand files into resources
    local enemies = ResourceManager.loadEnemyMap(enemyMapFile, levelName)
    local terrain = ResourceManager.loadTerrain(getRootLevelDirectory(levelName) .. levelFile.terrainFile)
    local backgroundLayer = ResourceManager.loadLayer(backgroundLayerFile, levelName)
    local backForegroundLayer = ResourceManager.loadLayer(backForegroundLayerFile, levelName)
    local functionalLayer = ResourceManager.loadLayer(functionalLayerFile, levelName)
    local foregroundLayer = ResourceManager.loadLayer(foregroundLayerFile, levelName)

    -- Done!
    return Level:new(levelFile.startPoint, levelFile.finishLine, levelFile.timeToComplete,
                     enemies, terrain, backgroundLayer, backForegroundLayer, functionalLayer,
                     foregroundLayer)
end

return ResourceManager
