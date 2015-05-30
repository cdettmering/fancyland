--- Player ---

-- Setup local access
local ResourceManager = require('ResourceManager')
local Actor = require('Actor')
local Body = require(PHYSICSPATH .. 'Body')
local BodyPart = require(PHYSICSPATH .. 'BodyPart')
local Shape = require(MATHPATH .. 'Shape')
local Point = require(MATHPATH .. 'Point')
local MathUtil = require(MATHPATH .. 'MathUtil')
local absoluteValue = math.abs

local Player = {}
local Player_mt = {}
Player_mt.__index = Player

local TAG = 'Player'

-- Setup some constants
Player.WIDTH = 50
Player.HEIGHT = 100
Player.BODY_WIDTH = 50
Player.BODY_HEIGHT = 80
Player.FEET_WIDTH = 30
Player.FEET_HEIGHT = 20
Player.BODYPART_TORSO = 'TORSO'
Player.BODYPART_FEET = 'FEET'
Player.RUN_FORCE = 5
Player.JUMP_FORCE = -300
Player.MAX_RUNFORCE = 300
Player.KNOCKDOWN_TIME = 2

-- Setup some variables
Player._isJumping = false
Player._isKnockedDown = false
Player._knockDownElapsedTime = 0

local function getGeometricCenter()
    -- find center of torso
    local torsoCenter = Player._torso:shape():center()

    -- get top left of torso
    local torsoTopLeft = torsoCenter - Point:new(Player.BODY_WIDTH / 2, Player.BODY_HEIGHT / 2)

    -- get geometric center
    return torsoTopLeft + Point:new(Player.WIDTH / 2, Player.HEIGHT / 2)
end

local function onTorsoCollision(body, point)
    --Log.info(TAG, 'Torso colliding with ' .. body:type())
    if body:type() == BODYTYPE_TERRAIN then
        -- is the intersecton point to the right?
        if (Player.actor:body():position().x - point.x) < 0 then
            -- negate x movement
            Player.actor:body():applyImpulse(Point:new(-Player.actor:body():velocity().x))
        end

        -- is the intersection point up above?
        if (Player.actor:body():position().y - point.y) < 0 then
            -- negate y movement
            Player.actor:body():applyImpulse(Point:new(Player.actor:body():velocity().y))
        end
    elseif body:type() == BODYTYPE_ENEMY then
        Player.knockDown()
    end
end

local function onFeetCollision(body, point)
    --Log.info(TAG, 'Feet colliding with ' .. body:type())
    -- are the feet intersecting with terrain?
    if body:type() == BODYTYPE_TERRAIN then
        Player._isJumping = false

        -- negate y movement
        Player.actor:body():applyImpulse(Point:new(0, -Player.actor:body():velocity().y))

        -- move player above terrain, to correct tunneling
        local bottomOfFeet = Player._feet:shape():center().y + (Player.FEET_HEIGHT / 2)
        local deltaY = absoluteValue(bottomOfFeet - point.y)
        Player.actor:body():move(Player.actor:body():position() - Point:new(0, deltaY))
    elseif body:type() == BODYTYPE_ENEMY then
        Player.knockDown()
    end
end


function Player.load()
    -- Create the body
    Player._torso = BodyPart:new(
                        Player.BODYPART_TORSO,
                        Shape:new(
                            Point:new(0, 0),
                            Point:new(Player.BODY_WIDTH, 0),
                            Point:new(Player.BODY_WIDTH, Player.BODY_HEIGHT),
                            Point:new(0, Player.BODY_HEIGHT)
                        )
                    )
    Player._feet = BodyPart:new(
                        Player.BODYPART_FEET,
                        Shape:new(
                            Point:new((Player.BODY_WIDTH / 2) - (Player.FEET_WIDTH / 2), Player.BODY_HEIGHT),
                            Point:new((Player.BODY_WIDTH / 2) - (Player.FEET_WIDTH / 2) + Player.FEET_WIDTH, Player.BODY_HEIGHT),
                            Point:new((Player.BODY_WIDTH / 2) - (Player.FEET_WIDTH / 2) + Player.FEET_WIDTH, Player.HEIGHT),
                            Point:new((Player.BODY_WIDTH / 2) - (Player.FEET_WIDTH / 2), Player.HEIGHT)
                        )
                    )

    local body = Body:new(BODYTYPE_PLAYER, Player._torso, Player._feet)

    -- Load sprite
    local sprite = ResourceManager.loadSprite('player.png')

    Player.actor = Actor:new(sprite, body)
end

function Player.update(dt)
    -- if the Player is not knocked down, then run
    if not Player._isKnockedDown then
        -- Run
        Player.actor:body():applyImpulse(Point:new(Player.RUN_FORCE))

        -- cap the run force
        if Player.actor:body():velocity().x > Player.MAX_RUNFORCE then
            local difference = Player.actor:body():velocity().x - Player.MAX_RUNFORCE
            Player.actor:body():applyImpulse(Point:new(-difference))
        end
    -- try to see if the player can get back up
    else
        Player._knockDownElapsedTime = Player._knockDownElapsedTime + dt
        if Player._knockDownElapsedTime > Player.KNOCKDOWN_TIME then
            Player._isKnockedDown = false
            Player._knockDownElapsedTime = 0
        end
    end

    -- Gravity
    Player.actor:body():applyForce(Point:new(0, GRAVITY))
end

function Player.draw()
    -- draw at geometric center of vampire
    local x = Player.WIDTH / 2
    local y = Player.HEIGHT / 2
    local drawPoint = getGeometricCenter()
    love.graphics.draw(Player.actor:sprite(), drawPoint.x, drawPoint.y, Player.actor:body():orientation(), 1, 1, x, y) 
end

function Player.move(point)
    Player.actor:body():move(point)
end

function Player.jump()
    if not Player._isJumping and not Player._isKnockedDown then
        Log.info(TAG, 'Jumping')
        Player._isJumping = true
        Player.actor:body():applyImpulse(Point:new(0, Player.JUMP_FORCE))
    end
end

function Player.knockDown()
    if not Player._isKnockedDown then
        Log.info(TAG, 'Knocked Down')
        Player._isKnockedDown = true
        -- negate x movement
        Player.actor:body():applyImpulse(Point:new(-Player.actor:body():velocity().x))
    end
end

function Player.onCollision(body1, body2, intersections)
    -- figure out which body is the player
    local player = {}
    local other = {}
    if body1:type() == BODYTYPE_PLAYER then
        player = body1
        other = body2
    else
        player = body2
        other = body1
    end

    -- check for feet and torso collision
    for _, element in ipairs(intersections) do
        if element.part1:type() == Player.BODYPART_TORSO or element.part2:type() == Player.BODYPART_TORSO then
            onTorsoCollision(other, MathUtil.averagePoints(element.points))
        elseif element.part1:type() == Player.BODYPART_FEET or element.part2:type() == Player.BODYPART_FEET then
            onFeetCollision(other, MathUtil.averagePoints(element.points))
        end
    end
end

function Player.onClick(point)
    Player.jump()
end

return Player
