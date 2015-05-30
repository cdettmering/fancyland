local Point = require(MATHPATH .. 'Point')
local Shape = require(MATHPATH .. 'Shape')
local Body = require(PHYSICSPATH .. 'Body')
local BodyPart = require(PHYSICSPATH .. 'BodyPart')

return
{
    sprite = 'bat.png',
    body = Body:new(
               BODYTYPE_ENEMY,
               BodyPart:new(
                  'BatWing',
                   Shape:new(
                       Point:new(0, 0),
                       Point:new(100, 0),
                       Point:new(100, 51),
                       Point:new(0, 51))
                       )),
    type = 'Bat'
}
