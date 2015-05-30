--- LevelController ---

-- Setup local access
local LayerController = require('LayerController')
local Camera = require('Camera')
local Player = require('Player')
local Cursor = require('Cursor')
local Timer = require('Timer')
local Point = require(MATHPATH .. 'Point')
local Engine = require(PHYSICSPATH .. 'Engine')
local BodyPart = require(PHYSICSPATH .. 'BodyPart')
local Body = require(PHYSICSPATH .. 'Body')
local GraphicUtility = require(GRAPHICSPATH .. 'GraphicUtility')
local unpack = unpack
local floor = math.floor

local LevelController = {}
local LevelController_mt = {}
LevelController_mt.__index = LevelController

function LevelController:new(level)
    local controller = {}
    controller.level = level

    -- Put player at start point
    Player.move(controller.level.startPoint)

    -- create layer controllers
    controller.bgController = LayerController:new(controller.level.backgroundLayer)
    controller.bfgController = LayerController:new(controller.level.backForegroundLayer)
    controller.fController = LayerController:new(controller.level.functionalLayer)
    controller.fgController = LayerController:new(controller.level.foregroundLayer)

    -- Setup physics engine
    controller.engine = Engine:new()

    -- add Player to engine
    controller.engine:addBody(Player.actor:body())

    -- add level terrain to engine
    local terrainParts = {}
    for _, shape in ipairs(level.terrain:shapes()) do
        local part = BodyPart:new(BODYTYPE_TERRAIN, shape)
        table.insert(terrainParts, part)
    end
    controller.engine:addBody(Body:new(BODYTYPE_TERRAIN, unpack(terrainParts)))

    -- add enemies to engine
    for _, enemy in ipairs(controller.level.enemyList:enemies()) do
        controller.engine:addBody(enemy:actor():body())
    end

    -- Setup timer
    controller.timer = Timer:new(controller.level.timeToComplete)

    return setmetatable(controller, LevelController_mt)
end

function LevelController:update(dt)
    if not self.timer.isRunning then
        self.timer:start()
    end
    self.timer:update(dt)
    self:_cleanup()
    Player.update(dt)
    for _, enemy in ipairs(self.level.enemyList:enemies()) do
        enemy:update(dt)
    end
    self.engine:tick(dt)
    self:_checkWin()
    self:_checkLose()
end

function LevelController:draw()
    local x = Player.actor:body():position().x

    ---- draw layers
    self.bgController:draw(x)
    self.bfgController:draw(x)
    self.fController:draw(x)
    
    -- have camera follow player
    Camera.setAbsolutePosition(x - 400, 0)

    -- Draw all of the functional layer objects
    Camera.push()

    -- draw player
    Player.draw()

    -- draw enemies
    for _, enemy in ipairs(self.level.enemyList:enemies()) do
        enemy:draw()
    end

    GraphicUtility.drawDebugLevel(self)
    Camera.pop()

    -- draw final layer
    self.fgController:draw(x)

    -- draw time left
    -- TODO: Draw time
end

function LevelController:_cleanup()
    local remove = {}
    for i, enemy in ipairs(self.level.enemyList:enemies()) do
        if not enemy:actor():alive() then
            table.insert(remove, i)
        end
    end
    for _, index in ipairs(remove) do
        -- remove from engine, and enemy list
        self.engine:removeBody(self.level.enemyList:enemies()[index]:actor():body())
        table.remove(self.level.enemyList:enemies(), index)
    end
end

function LevelController:_onCollision(body1, body2, intersections)
    for _, i in ipairs(intersections) do
        for _, p in ipairs(i.points) do
            GraphicUtility.addPoint(p)
        end
    end
    if body1:type() == BODYTYPE_PLAYER or body2:type() == BODYTYPE_PLAYER then
        Player.onCollision(body1, body2, intersections)
    end
end

function LevelController:_onClick(point)
    -- the point is given in screen coordinates, need to transform to world coordinates.
    -- grab the viewport based on the camera 
    local world = point + Point:new(Camera._positionX, 0)

    -- check click on player and all enemies
    if Player.actor:body():isInside(world) then
        Player.onClick(world)
    end

    for _, enemy in ipairs(self.level.enemyList:enemies()) do
        if enemy:actor():body():isInside(world) then
            print('Clicked ' .. enemy:type())
            enemy:onClick(world)
        end
    end
end

function LevelController:_checkWin()
    if Player.actor:body():position().x >= self.level.finishLine then
        -- Win!
    end
end

function LevelController:_checkLose()
    if self.timer:getTimeRemaining() == 0 then
        -- Lose!
    end
end

return LevelController
