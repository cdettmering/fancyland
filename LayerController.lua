-- LayerController ---

-- Visual: Shows how the camera moves along the layer over time.
--
-- Step 1:
-- -----------------------------------------------------
-- | Trees | Caves | Mountains | Trees | Trees | Caves |
-- -----------------------------------------------------
-- ----------
-- | Camera |
-- ----------
--
-- Step 2:
-- -----------------------------------------------------
-- | Trees | Caves | Mountains | Trees | Trees | Caves |
-- -----------------------------------------------------
--    ----------
--    | Camera |
--    ----------
--
-- Step 3:
-- -----------------------------------------------------
-- | Trees | Caves | Mountains | Trees | Trees | Caves |
-- -----------------------------------------------------
--      ----------
--      | Camera |
--      ----------
--
-- Step 4:
-- -----------------------------------------------------
-- | Trees | Caves | Mountains | Trees | Trees | Caves |
-- -----------------------------------------------------
--          ----------
--          | Camera |
--          ----------
--
-- Step N:
-- -----------------------------------------------------
-- | Trees | Caves | Mountains | Trees | Trees | Caves |
-- -----------------------------------------------------
--                                              ----------
--                                              | Camera |
--                                              ----------

-- Setup local access
local Camera = require('Camera')
local floor = math.floor

local LayerController = {}
local LayerController_mt = {}
LayerController_mt.__index = LayerController

local function mapXPositionToTexture(x)
    -- first figure out which 'cell' the x position maps to
    local cell = floor(x / NATIVE_WIDTH)

    -- add 1, because that computation will give us a 0 based index, and Lua
    -- uses a 1 based index
    cell = cell + 1
    return cell
end


function LayerController:new(layer)
    local controller = {}
    controller._layer = layer

    return setmetatable(controller, LayerController_mt)
end

function LayerController:layer()
    return self._layer
end

function LayerController:draw(x)   

    -- The Layer's perception of where it should draw is based on the speed of
    -- the Layer.
    x = x * self._layer.speed

    -- Grab the 3 textures to draw, the texture after the current cell is always
    -- drawn so there isnt a blank hole when the current texture scrolls by.
    -- The previous texture is also drawn, since the boundaries between
    -- the textures is crossed in the middle of the screen (where the
    -- Vampire is).
    local firstTexture = mapXPositionToTexture(x)
    local secondTexture = firstTexture + 1
    local thirdTexture = firstTexture - 1

    -- compute how much x offset it should be drawn at, based on the current
    -- X position.
    local firstX = (firstTexture - 1) * NATIVE_WIDTH
    local secondX = (secondTexture - 1) * NATIVE_WIDTH
    local thirdX = (thirdTexture -1) * NATIVE_WIDTH

    -- Since the layers have a parallax effect, we cannot use an umbrella push, pop
    -- like in a normal game.
    local save = Camera._positionX
    Camera.setAbsolutePosition(x, 0)
    Camera.push()

    -- if nil, don't draw just leave blank
    if self._layer.textures[firstTexture] ~= nil then
        love.graphics.draw(self._layer.textures[firstTexture], firstX, 0, 0, 1, 1, 0, 0)
    end

    if self._layer.textures[secondTexture] ~= nil then
        love.graphics.draw(self._layer.textures[secondTexture], secondX, 0, 0, 1, 1, 0, 0)
    end
    
    if self._layer.textures[thirdTexture] ~= nil then
        love.graphics.draw(self._layer.textures[thirdTexture], thirdX, 0, 0, 1, 1, 0, 0)
    end

    Camera.pop()
    Camera.setAbsolutePosition(save, 0)
end

return LayerController
