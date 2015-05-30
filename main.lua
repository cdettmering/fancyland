require('paths')
require('bodytypes')
require('data')

local Point = require(MATHPATH .. 'Point')
local LevelController = require('LevelController')
local ResourceManager = require('ResourceManager')

Player = require('Player')
Log = require('Log')
Cursor = require('Cursor')

local levelController = nil

local function onClick(point)
    levelController:_onClick(point)
end

local function onCollision(body1, body2, intersections)
    levelController:_onCollision(body1, body2, intersections)
end

function love.load()
    Player.load()
    levelController = LevelController:new(ResourceManager.loadLevel('testLevel'))
    levelController.engine:setCollisionCallback(onCollision)
    Cursor.setClickCallback(onClick)
    --font = love.graphics.newFont('content/fonts/york-script-es.ttf', 72)
    --love.graphics.setFont(font)
end

function love.update(dt)
    levelController:update(dt)
    Cursor.move(Point:new(love.mouse.getPosition()))
end

function love.draw()
    levelController:draw()
    Cursor.draw()
    --love.graphics.print('Fancy Land', 450, 300)
end

function love.keypressed(key, unicode)
    if key == ' ' then
        Player.jump()
    end
end

function love.mousepressed(x, y, button)
    if button == 'l' then
        Cursor.click(Point:new(x, y))
    end
end
