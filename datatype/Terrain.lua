--- Terrain ---

-- Setup local access
local Terrain = {}
local Terrain_mt = {}
Terrain_mt.__index = Terrain

-- Creates a new Terrain
-- param shapes: The Shape objects tha makeup the Terrain.
function Terrain:new(shapes)
    local terrain = {}
    terrain._shapes = shapes
    
    return setmetatable(terrain, Terrain_mt)
end

-- Returns the Shape objects that make up this terrain
function Terrain:shapes()
    return self._shapes
end

return Terrain
