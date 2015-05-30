--- Actor ---

-- Setup local access
local Point = require(MATHPATH .. 'Point')
local assert = assert

local Actor = {}
local Actor_mt = {}
Actor_mt.__index = Actor

-- Creates a new Actor
-- param sprite: The Image that represents this Actor.
-- param body: The Body that represents the shape of this Actor.
function Actor:new(sprite, body)
    assert(sprite ~= nil, 'Actor:new - Sprite parameter cannot be nil. Must provide a valid Image.')
    assert(body ~= nil, 'Actor:new - Body parameter cannot be nil. Must provide a valid Body.')
    local actor = {}
    actor._sprite = sprite
    actor._body = body
    actor._alive = true

    return setmetatable(actor, Actor_mt)
end

function Actor:sprite()
    return self._sprite
end

function Actor:body()
    return self._body
end

function Actor:alive()
    return self._alive
end

return Actor
