--- Camera --- 

-- Camera is designed to act like a real life camera as much as possible. This 
-- is achieved by having simple functions that can move, rotate, and zoom the
-- Camera which allows for easy scene configuring.

-- Setup local access
local Camera = {}
Camera.__index = Camera
Camera._positionX = 0
Camera._positionY = 0
Camera._scaleX = 1
Camera._scaleY = 1
Camera._rotation = 0

--pushes the Camera transformation onto the stack
function Camera.push()
    love.graphics.push()
    love.graphics.rotate(-Camera._rotation)
    love.graphics.scale(Camera._scaleX, Camera._scaleY)
    love.graphics.translate(-Camera._positionX, -Camera._positionY)
end

--pops the Camera transformation off of the stack
function Camera.pop()
    love.graphics.pop()
end

-- Moves the Camera relative to its current position
-- param dx: The amount to  move in the x direction (delta x)
-- param dy: The amount to move in the y direction (delta y)
function Camera.move(dx, dy)
    Camera._positionX = Camera._positionX + (dx or 0)
    Camera._positionY = Camera._positionY + (dy or 0)
end

-- Rotates the Camera relative to its current rotation
-- param radians: The angle to rotate by (in radians)
function Camera.rotate(radians)
    Camera._rotation = Camera._rotation + (radians or 0)
end

-- Zooms the Camera in and out relative to its current zoom
-- param dz: The amount to zoom by
function Camera.zoom(dz)
   Camera._scaleX = Camera._scaleX * (dz or 0)
   Camera._scaleY = Camera._scaleY * (dz or 0)
end

-- Sets the absolute position of the Camera to (x, y)
-- param x: The x coordinate (in absolute coordinates)
-- param x: The y coordinate (in absolute coordinates)
function Camera.setAbsolutePosition(x, y)
    Camera._positionX = x or Camera._positionX
    Camera._positionY = y or Camera._positionY
end

-- Sets the absolute rotation of the Camera
-- param radians: The absolute angle (in radians)
function Camera.setAbsoluteRotation(radians)
    Camera._rotation = radians or Camera._rotation
end

-- Sets the absolute scale of the Camera (zoom in or out)
-- NOTE: The x scale will stretch the graphics horizontally, independent of the
--       y scale. The same thing applies to the y scale. If a uniform scale is
--       required move x and y by the same amount.
-- param x: The horizontal stretch
-- param y: The vertical stretch
function Camera.setAbsoluteScale(x, y)
    Camera._scaleX = x or Camera._scaleX
    Camera._scaleY = y or Camera._scaleY
end

return Camera
